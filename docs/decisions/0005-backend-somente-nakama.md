# ADR-0005: Backend com Nakama e PostgreSQL, sem API própria inicial

- **Status:** Aceito
- **Data:** 2026-11-24
- **Substitui:** ADR-0004

## Contexto

O ADR-0004 previa três serviços de backend (Nakama, API própria e PostgreSQL) e deixava como pendência reavaliar a API própria. A equipe é pequena: cada serviço a mais traz outra linguagem, outra rede interna, outras credenciais e outra superfície de ataque.

O Nakama já oferece: contas e autenticação, sessões, grupos, matchmaking, armazenamento em PostgreSQL, RPCs do servidor, hooks antes e depois de cada operação, banimento de usuários e um console administrativo com papéis separados.

## Alternativas

1. **Manter o ADR-0004 (Nakama + API própria + PostgreSQL):** separação forte, mas com o custo de operar dois serviços de backend desde o início.
2. **Somente Nakama + PostgreSQL, com regras de negócio em módulos de runtime do Nakama.**

## Decisão

Opção 2.

- Regras de negócio (progresso, recompensas, autorização de acesso, auditoria) ficam em **módulos de runtime do Nakama**, executados no servidor.
- O servidor de partidas Godot fala com o Nakama por RPC de servidor, com chave própria. O cliente nunca chama regras de recompensa diretamente.
- Gestão de contas e suspensões usa o **console do Nakama**, com papéis separados. Painel próprio só quando operadores não técnicos precisarem.
- **Integração com o DesbravaClube adiada** até conhecermos a interface que ele oferece (OAuth, API ou nenhuma). Até lá, as contas existem só no Nakama. As regras do PLANO_MESTRE §6.2 continuam valendo quando ela for feita.
- Uma API própria só volta se surgir regra que os módulos do Nakama não suportem com testes e auditoria adequados. Isso exige um novo ADR.

## Pendências

- Linguagem dos módulos de runtime (TypeScript ou Go): decidir em ADR no início da Fase 3, junto com as ferramentas de teste e análise.
- Como modelar as entidades do PLANO_MESTRE §7 sobre o Nakama (motor de armazenamento ou tabelas próprias): decidir no mesmo momento.

## Consequências

- Um serviço de backend a menos para operar, proteger e monitorar.
- O projeto fica mais acoplado ao Nakama. Para reduzir o risco, as regras de negócio ficam em funções testáveis, separadas do código de registro de hooks.
- Identidade, sessões e grupos (PLANO_MESTRE §7.1) passam a ser do Nakama, não de tabelas próprias.
