# ADR-0004: Nakama, API própria e PostgreSQL no backend

- **Status:** Substituído por [ADR-0005](0005-backend-somente-nakama.md)
- **Data:** 2026-11-24

## Contexto

O jogo precisa de contas, sessões, matchmaking, regras de negócio (progresso, recompensas, autorização, integração com o DesbravaClube) e uma fonte oficial de dados persistentes. Construir autenticação e matchmaking do zero é caro e arriscado.

## Alternativas

1. **Tudo em API própria:** controle total, mas reimplementa autenticação, sessões e matchmaking.
2. **Tudo no Nakama (módulos de runtime):** menos serviços para operar; regras de negócio ficam presas ao runtime do Nakama.
3. **Nakama + API própria + PostgreSQL:** cada serviço com uma responsabilidade (PLANO_MESTRE §3.2).

## Decisão

Opção 3:

- **Nakama:** autenticação, sessões, presença, grupos e matchmaking.
- **API própria:** regras de negócio, autorização, integração com DesbravaClube, progresso, administração e auditoria.
- **PostgreSQL:** fonte oficial dos dados persistentes. Nakama e API usam bancos e usuários separados, com privilégio mínimo. O cliente nunca acessa o banco.

## Pendências (resolver antes da Fase 3, cada uma com novo ADR)

1. **Linguagem e framework da API própria.** Define também as ferramentas de teste e análise do backend (PLANO_MESTRE §8.1).
2. **Reavaliar a necessidade da API separada.** Se os módulos de runtime do Nakama atenderem às regras de negócio com testes e auditoria adequados, um serviço a menos reduz custo e superfície de ataque.
3. **Fluxo de vínculo com o DesbravaClube**, que depende do que o DesbravaClube oferece (OAuth, API, códigos temporários).

## Consequências

- Mais de um serviço para operar, monitorar e proteger.
- Chamadas entre Nakama, API e servidor de partidas precisam de autenticação entre serviços.
