# ADR-0001: Registrar decisões arquiteturais com ADRs

- **Status:** Aceito
- **Data:** 2026-11-24

## Contexto

O plano mestre (§11) exige que toda decisão arquitetural importante tenha registro com contexto, alternativas, decisão, consequências e status. Sem registro, decisões se perdem e são refeitas por tentativa e erro, inclusive por agentes de IA.

## Alternativas

1. Registrar decisões só em issues e PRs: difícil de encontrar depois.
2. Wiki externa: separa a decisão do código que ela afeta.
3. Arquivos Markdown versionados no repositório (ADRs).

## Decisão

Usar ADRs em `docs/decisions/`, um arquivo por decisão, nome `NNNN-titulo-curto.md`, em português.

- Status possíveis: **Proposto**, **Aceito**, **Rejeitado**, **Substituído por ADR-NNNN**.
- O ADR entra no mesmo PR da mudança que ele justifica.
- ADR aceito não é reescrito. Para mudar a decisão, cria-se um novo ADR que substitui o anterior.

## Consequências

- Agentes de IA e novos membros leem os ADRs antes de alterar a arquitetura (AGENTS.md).
- Pequeno custo de escrita por decisão.

## Modelo

```markdown
# ADR-NNNN: <Título>

- **Status:** Proposto
- **Data:** AAAA-MM-DD

## Contexto
<Problema e restrições.>

## Alternativas
<Opções consideradas, com prós e contras.>

## Decisão
<O que foi decidido.>

## Consequências
<O que melhora, o que piora, o que precisa ser feito depois.>
```
