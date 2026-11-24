# ADR-0007: Executor de testes mínimo em GDScript

- **Status:** Aceito
- **Data:** 2026-11-24

## Contexto

O ADR-0002 deixou para a Fase 1 a escolha da ferramenta de testes do GDScript. Hoje os testes verificam regras puras (movimento) e a integridade do projeto (ações de entrada, cena principal).

## Alternativas

1. **GUT** ou **GdUnit4:** completos (dublês, cenas, relatórios), mas são addons com centenas de arquivos copiados para o repositório e que precisam acompanhar cada versão do Godot.
2. **Executor próprio** (`game/tests/run.gd`, ~30 linhas), sem dependência.

## Decisão

Opção 2.

- Arquivos `game/tests/unit/test_*.gd`, com funções `test_*` que retornam `""` quando passam ou a mensagem de falha.
- Comando: `godot --headless --path game -s res://tests/run.gd`. Sai com código 1 se algum teste falhar, se um arquivo não carregar ou se nenhum teste for encontrado.

## Gatilhos para rever

Migrar para GUT ou GdUnit4 quando precisarmos de dublês (mocks), testes de cena com vários quadros ou relatórios para o CI.

## Consequências

- Nenhuma dependência nova.
- Sem recursos avançados: testes assíncronos ou com simulação de vários quadros ainda não são suportados.
