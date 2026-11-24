# Como contribuir

Toda contribuição segue o processo da seção 5.1 do [plano mestre](docs/PLANO_MESTRE.md). Agentes de IA também seguem o [AGENTS.md](AGENTS.md).

## Fluxo

1. **Issue.** Abrir com o template "Funcionalidade" ou "Bug": problema, comportamento esperado, módulos afetados, riscos de segurança e critérios de aceite.
2. **Plano.** Analisar a arquitetura existente e registrar o plano na issue. Se envolver decisão arquitetural, propor um ADR (`docs/decisions/`).
3. **Branch.** Criar a partir de `main`.
4. **Implementação.** Alterações pequenas, com testes automatizados para regras importantes.
5. **Verificação local.** Executar testes, análise estática e verificações de segurança.
6. **Pull Request.** Preencher o template por completo e revisar o próprio diff antes de pedir revisão.
7. **Integração.** Somente com CI aprovado, revisão aprovada e critérios de aceite atendidos.
8. **Homologação e produção.** Por processo controlado (a ser definido na Fase 5).

## Branches

| Branch | Uso |
|---|---|
| `main` | Código aprovado. Ninguém envia direto: só por PR revisado e com CI aprovado. |
| `feature/<issue>-<descricao>` | Funcionalidades. Ex.: `feature/12-movimentacao-personagem` |
| `fix/<issue>-<descricao>` | Correções. |
| `hotfix/<issue>-<descricao>` | Correções urgentes em produção. |

A branch `develop` só será criada se a equipe precisar dessa etapa (PLANO_MESTRE §8.2).

## Commits

Formato: `<tipo>: <descrição no imperativo>`, em português.

Tipos: `feat`, `fix`, `docs`, `test`, `refactor`, `ci`, `chore`.

Exemplo: `feat: validar distância na interação de coleta`

## Padrões de código

- Funções pequenas, com responsabilidade clara e nomes consistentes.
- Tratamento explícito de erros e validação de entradas.
- GDScript: guia de estilo oficial do Godot, tipagem estática e avisos do editor sem pendências.
- Sem código morto, sem dependências desnecessárias e sem abstrações sem uso.
- Comentários só para explicar o *porquê* de decisões não óbvias.

## Definição de Pronto

Uma tarefa só está pronta quando: implementação concluída, critérios de aceite atendidos, testes pertinentes executados, código revisado, segurança analisada, documentação atualizada, pipeline aprovado, sem erros críticos conhecidos e homologação concluída (quando aplicável). Compilar ou "funcionar na tela" não basta.

## Decisões arquiteturais (ADR)

Copiar o modelo do [ADR-0001](docs/decisions/0001-registrar-decisoes-com-adr.md), numerar em sequência e abrir no mesmo PR da mudança. ADR aceito não é editado: é substituído por um novo.
