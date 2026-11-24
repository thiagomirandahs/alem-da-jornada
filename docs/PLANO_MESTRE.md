# ALÉM DA JORNADA
## Plano de Desenvolvimento, Arquitetura de Software e Padrões de Engenharia

**Documento:** Plano Mestre de Desenvolvimento  
**Versão:** 1.1  
**Status:** Proposta de referência para início do projeto  

> **Revisão 1.1 (2026-11-24):** backend reduzido a Nakama + PostgreSQL, sem API própria inicial ([ADR-0005](decisions/0005-backend-somente-nakama.md)). K3s, Agones, Prometheus, Grafana e Loki adiados até que a medição justifique ([ADR-0006](decisions/0006-infraestrutura-proporcional-a-medicao.md)). Integração com o DesbravaClube adiada até conhecermos a interface dele. Homologação só a partir da existência de produção.

**Plataformas:** Windows e Android  
**Engine:** Godot 4.x  
**Linguagem principal:** GDScript  
**Modelo multiplayer:** Servidores dedicados e autoritativos  
**Público:** Desbravadores cadastrados e autorizados  
**Meta de escala:** 4.000 ou mais contas, com capacidade de pico a ser comprovada por testes.

---

# 1. VISÃO DO PROJETO

Além da Jornada será um jogo 3D cooperativo, educativo e baseado em experiências, inspirado em princípios e histórias bíblicas.

O jogador participará de campanhas divididas em missões independentes. Em vez de responder apenas a perguntas, deverá explorar ambientes, cooperar com outros jogadores, resolver problemas, administrar recursos e tomar decisões.

O jogo será desenvolvido para Windows e Android, com suporte a partidas multiplayer.

## 1.1 Objetivos do produto

- Criar uma experiência 3D cooperativa.
- Trabalhar valores cristãos por meio de situações jogáveis.
- Permitir campanhas e missões independentes.
- Atender jogadores de diferentes faixas etárias.
- Possibilitar expansão de conteúdo sem reconstruir a infraestrutura.
- Integrar futuramente o sistema de contas ao DesbravaClube.
- Atender milhares de usuários cadastrados.
- Preparar a arquitetura para picos elevados de jogadores simultâneos.

## 1.2 Princípios de desenvolvimento

1. Segurança antes de conveniência.
2. Arquitetura antes de implementação desordenada.
3. Código compreensível e testável.
4. Nenhuma funcionalidade sem critérios de aceite.
5. Nenhuma alteração de banco sem migração versionada.
6. Nenhuma regra importante confiada exclusivamente ao cliente.
7. Nenhuma entrega considerada concluída sem testes.
8. Nenhuma capacidade de escala declarada sem medição.
9. Nenhuma dependência externa sem avaliação de segurança e manutenção.
10. Nenhum código gerado por IA será aceito sem compreensão, revisão e validação.

---

# 2. ESCOPO FUNCIONAL

## 2.1 Funcionalidades do jogador

O jogador deverá ter acesso a:

- Cadastro e autenticação.
- Recuperação de conta.
- Vínculo opcional com o DesbravaClube.
- Personagem personalizado.
- Identificação e perfil dentro do jogo.
- Seleção de campanhas.
- Seleção de missões.
- Formação de equipes.
- Matchmaking.
- Partidas cooperativas.
- Sistema de progresso.
- Conquistas e recompensas.
- Histórico de missões.
- Configurações de áudio, vídeo e controles.

## 2.2 Funcionalidades administrativas

O sistema administrativo deverá permitir:

- Gerenciar contas.
- Consultar vínculos com clubes.
- Conceder ou revogar acesso autorizado.
- Suspender contas.
- Gerenciar campanhas.
- Gerenciar missões.
- Publicar versões de conteúdo.
- Consultar resultados e métricas.
- Consultar denúncias.
- Auditar ações administrativas.
- Consultar indicadores de infraestrutura.

As permissões administrativas deverão ser separadas por função. Nenhum administrador terá acesso irrestrito automaticamente.

Na primeira versão, as funções administrativas usam o console do Nakama, que tem papéis separados. Um painel próprio só será construído quando operadores não técnicos precisarem dele (ADR-0005).

## 2.3 Primeira versão jogável

A primeira versão terá como referência a campanha de José no Egito.

Missões previstas:

1. A grande colheita.
2. O transporte dos alimentos.
3. Organização dos armazéns.
4. Preparação para o período de escassez.
5. Distribuição dos recursos.
6. Resolução de uma decisão difícil.

Cada missão deverá possuir objetivos, condições de conclusão, regras, checkpoints e critérios de recompensa próprios.

---

# 3. ARQUITETURA DE SOFTWARE

## 3.1 Tecnologias de referência

| Camada | Tecnologia |
|---|---|
| Engine | Godot 4.x |
| Linguagem do jogo | GDScript |
| Cliente | Windows e Android |
| Servidor de partidas | Godot Headless |
| Autenticação e sessões | Nakama |
| Regras de negócio | Módulos de runtime do Nakama (ADR-0005) |
| Banco de dados | PostgreSQL |
| Containers | Docker |
| Orquestração | Processos em VPS; K3s só se a medição exigir (ADR-0006) |
| Gerenciamento de partidas | Alocador simples; Agones só se a medição exigir (ADR-0006) |
| Monitoramento | Métricas do Nakama e do servidor de partidas; Prometheus e Grafana se necessário |
| Logs | Logs dos containers; Loki se necessário |
| Distribuição de arquivos | Object Storage e CDN |
| Controle de versão | Git e GitHub |
| Automação | GitHub Actions |

As versões deverão ser fixadas em arquivo de configuração e atualizadas por processo controlado.

## 3.2 Responsabilidade de cada componente

### Godot Client

Responsável por:

- Renderização.
- Interface.
- Controles.
- Câmera.
- Animações.
- Áudio.
- Apresentação dos ambientes.
- Envio de comandos aos servidores.
- Recebimento e interpolação de estados.

O cliente não será responsável por decidir resultados oficiais, conceder recompensas ou validar conclusões de missão.

### Godot Dedicated Server

Responsável por:

- Executar a simulação da missão.
- Controlar o estado oficial da partida.
- Validar movimentação e interações.
- Controlar recursos disponíveis.
- Validar objetivos.
- Controlar checkpoints.
- Determinar o resultado.
- Encaminhar eventos relevantes para persistência.

O servidor deverá funcionar sem interface gráfica e sem depender de recursos locais do cliente.

### Nakama

Responsável por:

- Autenticação.
- Sessões.
- Presença.
- Grupos.
- Matchmaking.
- Comunicação de serviços de multiplayer.
- Regras de negócio, em módulos de runtime: autorização, progresso, validação de resultados, recompensas, auditoria e operações persistentes (ADR-0005).
- Administração inicial, pelo console com papéis separados.
- Integração com o DesbravaClube, quando a interface dele for conhecida.

A execução do mundo 3D continuará sendo responsabilidade dos servidores dedicados Godot.

Uma API própria separada só será criada, com novo ADR, se surgir regra que os módulos do Nakama não suportem.

### PostgreSQL

Será a fonte oficial dos dados persistentes do jogo.

O banco armazenará identidades internas, vínculos externos, personagens, campanhas, missões, progresso, partidas, resultados, recompensas e auditoria.

Não será permitido que o cliente acesse diretamente o banco de dados.

---

# 4. ESTRUTURA DO REPOSITÓRIO

Nome sugerido: `alem-da-jornada`.

```text
alem-da-jornada/
│
├── game/
│   ├── client/
│   │   ├── scenes/
│   │   ├── scripts/
│   │   ├── ui/
│   │   ├── controllers/
│   │   ├── audio/
│   │   ├── animations/
│   │   └── resources/
│   │
│   ├── server/
│   │   ├── bootstrap/
│   │   ├── networking/
│   │   ├── simulation/
│   │   ├── validation/
│   │   ├── missions/
│   │   └── persistence/
│   │
│   ├── shared/
│   │   ├── contracts/
│   │   ├── enums/
│   │   ├── models/
│   │   └── constants/
│   │
│   └── assets/
│
├── backend/
│   ├── nakama/
│   │   ├── modules/
│   │   ├── tests/
│   │   └── configuration/
│   │
│   └── allocator/
│       ├── src/
│       └── tests/
│
├── database/
│   ├── migrations/
│   ├── seeds/
│   └── documentation/
│
├── infra/
│   ├── docker/
│   ├── networking/
│   └── backup/
│
├── tests/
│   ├── unit/
│   ├── integration/
│   ├── multiplayer/
│   ├── security/
│   ├── performance/
│   └── end_to_end/
│
├── docs/
│   ├── architecture/
│   ├── decisions/
│   ├── security/
│   ├── api/
│   ├── database/
│   ├── operations/
│   └── development/
│
├── tools/
│
├── .github/
│   ├── ISSUE_TEMPLATE/
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── workflows/
│
├── .gitignore
├── README.md
├── CONTRIBUTING.md
├── SECURITY.md
├── AGENTS.md
└── LICENSE
```

A estrutura é uma referência inicial. Os diretórios serão criados conforme cada módulo for implementado, evitando arquivos vazios e abstrações sem utilidade.

---

# 5. PADRÃO DE ENGENHARIA: PROIBIÇÃO DE DESENVOLVIMENTO POR TENTATIVA E ERRO

O projeto não deverá seguir o modelo de desenvolvimento conhecido como vibe coding, em que grandes quantidades de código são geradas sem análise suficiente, compreensão ou validação.

A inteligência artificial poderá auxiliar no desenvolvimento, mas não será responsável por decidir sozinha a arquitetura, aprovar segurança ou declarar funcionalidades concluídas.

## 5.1 Processo obrigatório para cada funcionalidade

Toda funcionalidade seguirá este fluxo:

1. Criar uma issue no GitHub.
2. Descrever o problema e o comportamento esperado.
3. Identificar os módulos afetados.
4. Avaliar riscos de segurança.
5. Definir critérios de aceite.
6. Analisar a arquitetura existente.
7. Elaborar plano de implementação.
8. Implementar em alterações pequenas.
9. Criar testes automatizados.
10. Executar testes locais.
11. Executar análise estática e verificações de segurança.
12. Revisar o código e as dependências.
13. Criar Pull Request.
14. Revisar o diff completo.
15. Integrar somente após aprovação dos critérios.
16. Publicar em ambiente de homologação.
17. Validar o comportamento.
18. Liberar para produção por processo controlado.

Os passos 16 a 18 valem a partir da existência de um ambiente de produção (Fase 5). Até lá, o fluxo termina na integração à `main`.

## 5.2 Regras para código produzido por IA

É proibido:

- Aceitar código sem ler o conteúdo.
- Criar funções duplicadas para contornar erros.
- Desabilitar validações para fazer testes passarem.
- Ignorar erros de compilação.
- Ocultar exceções sem justificativa.
- Criar permissões administrativas genéricas.
- Armazenar segredos no código.
- Implementar regras de negócio apenas na interface.
- Criar migrações destrutivas sem plano de recuperação.
- Aumentar permissões de rede sem justificativa.
- Declarar testes executados sem realmente executá-los.
- Marcar uma tarefa como concluída sem critérios de aceite atendidos.

A IA deverá primeiro inspecionar o código existente e explicar quais arquivos serão afetados antes de realizar alterações relevantes.

## 5.3 Padrões de qualidade

- Funções pequenas e com responsabilidade clara.
- Separação entre domínio, aplicação e infraestrutura.
- Nomes consistentes.
- Tratamento explícito de erros.
- Validação de entradas.
- Tipagem sempre que aplicável.
- Documentação das decisões não óbvias.
- Testes automatizados para regras importantes.
- Ausência de código morto e dependências desnecessárias.

Não será exigido criar abstrações para tudo. A arquitetura deve ser organizada, mas proporcional à complexidade real.

---

# 6. SEGURANÇA DA APLICAÇÃO

Segurança será um requisito de arquitetura, não uma etapa final.

## 6.1 Identidade e autenticação

- Identificadores internos independentes do DesbravaClube.
- Senhas armazenadas por provedor confiável, usando mecanismos modernos de hash.
- Tokens com validade e escopo definidos.
- Rotação e revogação de sessões.
- Proteção contra força bruta.
- Limitação de tentativas de login.
- Recuperação de conta com verificação segura.
- Separação entre autenticação e autorização.

## 6.2 Integração com DesbravaClube

O jogo não confiará em informações enviadas pelo cliente para comprovar associação a um clube.

O vínculo será realizado por fluxo seguro entre os servidores.

Regras:

- Nunca solicitar senha do DesbravaClube.
- Nunca confiar em `club_id` informado livremente pelo cliente.
- Validar a identidade no backend.
- Utilizar códigos temporários de vinculação.
- Utilizar comunicação autenticada entre sistemas.
- Registrar eventos de vinculação e desvinculação.
- Permitir revogação de autorização.

A integração fica adiada até conhecermos a interface oferecida pelo DesbravaClube. Até lá, as contas existem somente no Nakama (ADR-0005).

## 6.3 Autorização

Será adotado controle de acesso baseado em funções e permissões.

Exemplos:

- Jogador.
- Moderador.
- Administrador de conteúdo.
- Administrador operacional.
- Administrador da plataforma.

As permissões serão verificadas no backend em cada operação protegida.

## 6.4 Segurança do multiplayer

O servidor será autoritativo.

O cliente poderá solicitar:

- Movimentação.
- Interação.
- Coleta.
- Transporte.
- Construção.
- Uso de recursos.

O servidor validará:

- Identidade do jogador.
- Participação na partida.
- Distância e posição.
- Disponibilidade do objeto.
- Regras da missão.
- Limites de velocidade e frequência.
- Estado atual da partida.

Nenhuma recompensa poderá ser concedida apenas porque o cliente enviou uma mensagem afirmando que concluiu a missão.

## 6.5 Segurança de infraestrutura

- SSH com chaves e acesso restrito.
- Desabilitar autenticação SSH por senha quando operacionalmente possível.
- Firewall com portas mínimas necessárias.
- Serviços internos em redes privadas.
- Banco de dados sem exposição pública.
- Segredos fora dos repositórios.
- Atualizações de segurança programadas.
- Containers executados sem privilégios desnecessários.
- Imagens fixadas por versão ou digest.
- Privilégio mínimo nos serviços.
- Backups criptografados.
- Monitoramento de eventos administrativos.
- Plano de recuperação de incidentes.

## 6.6 Segurança do banco

- Usuários separados por serviço.
- Privilégio mínimo.
- Transações nas operações críticas.
- Restrições de integridade.
- Índices definidos conforme consultas reais.
- Migrações versionadas.
- Auditoria de operações administrativas.
- Backups automáticos.
- Testes periódicos de restauração.

O serviço de partidas não deverá possuir permissões administrativas sobre o banco.

## 6.7 Proteção de crianças e adolescentes

A primeira versão não terá chat livre, mensagens privadas ou chamadas de voz.

Serão utilizados:

- Mensagens predefinidas.
- Pseudônimos.
- Denúncia e bloqueio.
- Moderação.
- Coleta mínima de dados.
- Controle de acesso.
- Políticas de privacidade.
- Fluxos apropriados de autorização dos responsáveis, quando aplicáveis.

A conformidade com a LGPD deverá ser avaliada antes do lançamento público.

---

# 7. MODELAGEM DE DADOS

As entidades principais serão:

Identidade, sessões e grupos são fornecidos pelo Nakama. A forma de modelar as demais entidades sobre o Nakama (motor de armazenamento ou tabelas próprias) será decidida em ADR no início da Fase 3 (ADR-0005).

## 7.1 Identidade

- users
- external_accounts
- access_grants
- user_sessions
- user_roles
- permissions

## 7.2 Conteúdo

- campaigns
- campaign_versions
- missions
- mission_versions
- mission_objectives
- mission_rewards
- game_assets

## 7.3 Jogabilidade

- characters
- character_customizations
- player_progress
- player_achievements
- player_inventory

## 7.4 Multiplayer

- mission_sessions
- mission_participants
- mission_results
- mission_checkpoints
- matchmaking_history

## 7.5 Administração e segurança

- moderation_reports
- moderation_actions
- audit_events
- access_logs
- security_events

Todas as entidades terão identificadores consistentes, relacionamentos explícitos e regras de integridade.

Dados transitórios da partida permanecerão em memória no servidor sempre que possível. Apenas informações relevantes serão persistidas.

Operações críticas deverão ser idempotentes para evitar recompensas duplicadas em caso de reconexão ou repetição de requisições.

---

# 8. SEGURANÇA E QUALIDADE NO CICLO DE ENTREGA

## 8.1 Pipeline de integração contínua

Cada Pull Request deverá executar:

1. Verificação de formatação.
2. Análise estática.
3. Verificação de compilação.
4. Testes unitários.
5. Testes de integração aplicáveis.
6. Verificação de dependências.
7. Verificação de segredos.
8. Análise de vulnerabilidades.
9. Verificação de migrações.
10. Construção dos artefatos.

Ferramentas possíveis:

- GDScript: GDScript warnings, GUT ou ferramenta de testes equivalente.
- Backend: framework de testes compatível com a linguagem escolhida.
- Dependências: Dependabot e ferramentas de análise de vulnerabilidades.
- Segredos: GitHub secret scanning ou ferramenta equivalente.
- Containers: Trivy.
- Qualidade: análise estática e linters adequados às tecnologias.

As ferramentas do backend serão selecionadas junto com a linguagem dos módulos do Nakama (TypeScript ou Go), no início da Fase 3.

## 8.2 Branches

Estratégia sugerida:

- `main`: código aprovado e pronto para produção.
- `develop`: integração contínua, caso a equipe precise dessa etapa.
- `feature/*`: funcionalidades.
- `fix/*`: correções.
- `hotfix/*`: correções urgentes.

Não será permitido enviar diretamente para `main` sem revisão e verificações obrigatórias.

## 8.3 Pull Requests

Todo PR deverá conter:

- Issue relacionada.
- Objetivo da alteração.
- Arquivos e módulos afetados.
- Riscos identificados.
- Testes realizados.
- Resultado dos testes.
- Impacto no banco.
- Impacto de segurança.
- Plano de reversão, quando aplicável.

## 8.4 Política de releases

- Versões identificadas.
- Builds reproduzíveis.
- Artefatos associados a commits.
- Homologação antes de produção.
- Migrações compatíveis com versões implantadas.
- Plano de rollback.
- Registro da versão em execução.

---

# 9. TESTES OBRIGATÓRIOS

## 9.1 Testes unitários

Validar isoladamente:

- Regras de movimentação.
- Coleta de recursos.
- Validação de objetivos.
- Conclusão de missões.
- Distribuição de recompensas.
- Permissões.
- Regras de progresso.

## 9.2 Testes de integração

Validar:

- Cliente e servidor.
- Servidor de partidas e Nakama.
- Nakama e PostgreSQL.
- Nakama e DesbravaClube, quando a integração existir.
- Matchmaking e alocador.
- Persistência de resultados.

## 9.3 Testes multiplayer

- Entrada de jogadores.
- Saída durante a partida.
- Reconexão.
- Perda de conexão.
- Duplicação de mensagens.
- Jogadores com latências diferentes.
- Encerramento inesperado de servidor.
- Partidas simultâneas.
- Isolamento entre salas.

## 9.4 Testes de segurança

- Tentativas de acesso não autorizado.
- Alteração de identificadores.
- Repetição de requisições.
- Falsificação de resultados.
- Elevação de privilégios.
- Exposição de dados.
- Manipulação de recompensas.
- Força bruta.
- Abuso de APIs.
- Acesso indevido a partidas.

## 9.5 Testes de desempenho

Etapas de referência (ADR-0006):

- 2 jogadores.
- 8 jogadores, medindo o custo de uma partida (CPU, RAM e banda) na Fase 2.
- 100 jogadores.
- Pico simultâneo estimado, calculado a partir do custo por partida e do uso real dos clubes.
- 1,5 vez o pico estimado, como margem.

Testes com 4.000 jogadores ou mais só serão feitos se a estimativa de pico indicar essa necessidade. A meta de 4.000 contas não equivale a 4.000 jogadores simultâneos.

A quantidade de jogadores não será o único indicador. Também serão medidos CPU, RAM, latência, perda de pacotes, falhas, tempo de alocação e estabilidade.

---

# 10. PLANO DE DESENVOLVIMENTO POR FASES

## FASE 0 — Governança e fundação

Entregas:

- Repositório.
- AGENTS.md.
- README.md.
- SECURITY.md.
- CONTRIBUTING.md.
- ADRs iniciais.
- Estrutura de diretórios.
- Pipeline de CI.
- Convenções de desenvolvimento.
- Ambiente local reproduzível.

Critério de conclusão: outro desenvolvedor deve conseguir clonar o repositório, configurar o ambiente e executar o projeto seguindo a documentação.

## FASE 1 — Protótipo 3D

Entregas:

- Projeto Godot.
- Personagem.
- Movimentação.
- Câmera em terceira pessoa.
- Controles de PC.
- Controles de Android.
- Cenário inicial do Egito.
- Interações básicas.

Critério de conclusão: jogador consegue explorar e interagir com o cenário em ambas as plataformas.

## FASE 2 — Multiplayer autoritativo

Entregas:

- Servidor headless.
- Comunicação cliente-servidor.
- Criação de partidas.
- Entrada de jogadores.
- Sincronização.
- Validação de ações.
- Reconexão.
- Encerramento de partida.

Critério de conclusão: até oito jogadores conseguem executar uma missão básica em uma partida controlada pelo servidor.

## FASE 3 — Contas e persistência

Entregas:

- Nakama, com regras de negócio em módulos de runtime.
- PostgreSQL.
- Cadastro.
- Login.
- Sessões.
- Vínculo externo, se a interface do DesbravaClube já for conhecida.
- Autorização.
- Personagens.
- Persistência do progresso.

Critério de conclusão: usuário autorizado consegue entrar e manter seu progresso entre sessões.

## FASE 4 — Sistema de campanhas e missões

Entregas:

- Estrutura de campanhas.
- Sistema de objetivos.
- Checkpoints.
- Regras de conclusão.
- Recompensas.
- Histórico.
- Primeira campanha de José.

Critério de conclusão: campanha completa, com missões independentes e resultados persistidos.

## FASE 5 — Infraestrutura de produção

Entregas:

- VPS.
- Docker.
- Alocador simples (K3s e Agones só se a medição exigir, ADR-0006).
- PostgreSQL de produção.
- Backups.
- Monitoramento básico.
- Ambiente de homologação.
- CDN.
- Segurança operacional.

Critério de conclusão: partidas são alocadas, executadas e encerradas automaticamente, com métricas e recuperação operacional.

## FASE 6 — Testes e lançamento controlado

Entregas:

- Testes de carga.
- Testes de segurança.
- Testes em aparelhos reais.
- Piloto com usuários autorizados.
- Correções.
- Documentação operacional.
- Plano de suporte.
- Liberação gradual.

Critério de conclusão: critérios de segurança, qualidade, desempenho e operação aprovados.

---

# 11. DOCUMENTAÇÃO OBRIGATÓRIA

O projeto deverá manter os seguintes documentos atualizados:

| Documento | Conteúdo |
|---|---|
| README | Visão geral e execução |
| AGENTS | Regras para agentes de IA |
| SECURITY | Processo de segurança |
| CONTRIBUTING | Padrões de contribuição |
| ARCHITECTURE | Arquitetura geral |
| ADR | Decisões arquiteturais |
| DATABASE | Modelagem e migrações |
| API | Contratos e autenticação |
| MULTIPLAYER | Rede e simulação |
| OPERATIONS | Implantação e operação |
| DISASTER_RECOVERY | Recuperação de desastres |
| TESTING | Estratégia e execução dos testes |

Uma decisão arquitetural importante deverá possuir um ADR com contexto, alternativas, decisão, consequências e status.

---

# 12. DEFINIÇÃO DE PRONTO

Uma funcionalidade somente será considerada pronta quando:

- Implementação concluída.
- Critérios de aceite atendidos.
- Testes pertinentes executados.
- Código revisado.
- Segurança analisada.
- Documentação atualizada.
- Pipeline aprovado.
- Sem erros críticos conhecidos.
- Homologação concluída, quando aplicável.

Uma tarefa não poderá ser encerrada apenas porque a interface funciona ou porque o código compila.

---

# 13. PRINCIPAIS RISCOS E CONTROLES

| Risco | Controle |
|---|---|
| Servidor sobrecarregado | Testes de carga e escala horizontal |
| Pico real maior que o estimado | Medição na Fase 2 e gatilhos de revisão do ADR-0006 |
| Dependência do Nakama | Regras de negócio em funções testáveis, separadas dos hooks (ADR-0005) |
| Fraude em partidas | Servidor autoritativo |
| Vazamento de dados | Privilégio mínimo e proteção de credenciais |
| Perda de progresso | Transações, backups e recuperação |
| Falha de VPS | Separação de serviços e redundância |
| Crescimento de custos | Métricas de consumo e dimensionamento |
| Integração externa indisponível | Contratos, timeout e tolerância a falhas |
| Atualização incompatível | Versionamento e implantação controlada |
| Código gerado sem revisão | Processo obrigatório de PR e testes |
| Abuso por usuários | Moderação, limites e auditoria |

---

# 14. PRIMEIRA ENTREGA CONCRETA

O primeiro marco não será uma campanha inteira nem uma infraestrutura com milhares de jogadores.

Será a fundação técnica comprovada.

A primeira entrega deverá conter:

1. Repositório organizado.
2. Documentação inicial.
3. Projeto Godot executável.
4. Personagem com movimentação.
5. Câmera em terceira pessoa.
6. Cenário de teste.
7. Servidor Godot headless.
8. Dois clientes conectados ao mesmo servidor.
9. Interação validada pelo servidor.
10. Testes automatizados básicos.
11. Pipeline de integração contínua.
12. Relatório dos testes realizados.

Essa entrega permitirá decidir, com evidências, se a arquitetura de jogo e rede atende às necessidades antes de expandirmos o projeto.

---

# 15. DIRETRIZ FINAL

Além da Jornada deverá ser desenvolvido como um produto de software profissional, com responsabilidade sobre segurança, dados, infraestrutura e experiência dos jogadores.

A inteligência artificial será uma ferramenta de produtividade, não um substituto para engenharia, revisão e testes.

Nenhum código será considerado confiável apenas porque foi gerado corretamente, parece organizado ou funciona em uma demonstração.

**Nossa prioridade será construir uma base pequena, segura, documentada e testável, capaz de crescer sem exigir uma reconstrução completa do projeto.**
