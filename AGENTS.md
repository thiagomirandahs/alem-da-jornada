# Regras para agentes de IA

Este arquivo vale para qualquer agente de IA que trabalhe neste repositório (Claude, Copilot, Codex e outros). A IA é ferramenta de produtividade: ela não decide arquitetura sozinha, não aprova segurança e não declara nada concluído.

Fonte das regras: [docs/PLANO_MESTRE.md](docs/PLANO_MESTRE.md), seções 5, 6 e 12.

## Antes de alterar

1. Ler o código e a documentação que a alteração toca, incluindo os ADRs em `docs/decisions/`.
2. Explicar quais arquivos serão afetados e por quê, **antes** de alterações relevantes.
3. Trabalhar a partir de uma issue com critérios de aceite. Sem critério de aceite, perguntar.
4. Decisão arquitetural nova exige ADR proposto e aprovado por uma pessoa.

## Proibido

- Aceitar ou propor código sem ter lido o conteúdo.
- Criar funções duplicadas para contornar erros.
- Desabilitar validações, testes ou avisos para fazer algo passar.
- Ignorar erros de compilação ou ocultar exceções sem justificativa.
- Criar permissões administrativas genéricas.
- Armazenar segredos (senhas, tokens, chaves) em qualquer arquivo versionado.
- Implementar regra de negócio apenas no cliente ou na interface.
- Confiar em dados enviados pelo cliente (posição, resultado, recompensa, `club_id`).
- Criar migração destrutiva sem plano de recuperação.
- Aumentar permissões de rede, de banco ou de CI sem justificativa.
- Adicionar dependência sem avaliar segurança e manutenção.
- Declarar testes executados sem executá-los.
- Marcar tarefa como concluída sem os critérios da Definição de Pronto (PLANO_MESTRE §12).

## Regras de arquitetura que não mudam sem ADR

- O servidor de partidas é **autoritativo**: o cliente só envia comandos; o servidor valida e decide (ADR-0003).
- O cliente nunca acessa o banco de dados.
- Recompensas e progresso só são gravados pelo backend, de forma idempotente.
- A primeira versão não tem chat livre, mensagens privadas nem voz.

## Convenções

- Idioma da documentação, issues e PRs: português do Brasil.
- GDScript: seguir o guia de estilo oficial do Godot e usar tipagem estática.
- Versões fixadas em `versions.env`.
- Testes: `godot --headless --path game --import` e depois `godot --headless --path game -s res://tests/run.gd` (ADR-0007). Regras usadas pelo servidor ficam em `game/shared/` e têm teste. Teste de rede: `GODOT=<executável> bash game/tests/integration/run.sh`.
- Toda mensagem de rede é declarada só em `game/shared/session.gd`, com os argumentos validados no servidor e teste (ADR-0008). O servidor identifica o jogador por `multiplayer.get_remote_sender_id()`, nunca por campo da mensagem.
- Alterações pequenas, um assunto por PR.

## Ao terminar

Relatar o que foi alterado, quais testes foram executados (com o resultado real) e o que **não** foi verificado.
