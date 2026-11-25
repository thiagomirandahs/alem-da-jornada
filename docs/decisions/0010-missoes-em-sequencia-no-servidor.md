# ADR-0010: Missões como sequência de objetivos, decididas pelo servidor da partida

- **Status:** Proposto (aguarda aprovação de uma pessoa)
- **Data:** 2026-11-25

## Contexto

A missão 1 (PR #14) foi feita com a regra `Mission` fixa nos feixes de trigo (`WHEAT_PREFIX`). A campanha de José tem seis missões (PLANO_MESTRE §2.3), cada uma com objetivos, condições de conclusão, checkpoints e critério de recompensa próprios. A missão 2 (transporte dos alimentos) precisa de um estado novo (o que cada jogador carrega) e de uma ação nova (entregar). Sem decidir como missões se organizam, a missão 2 viraria cópia da 1.

## Alternativas

1. **Cada missão é um script próprio no servidor**, escolhido por nome. Simples, mas repete a plumbing (progresso, conclusão, mensagens) seis vezes.
2. **Missão como dados: lista de objetivos de tipos fixos** (`coletar N de X`, `entregar N de X em Z`), avaliados por uma regra pura em `game/shared/`. Uma missão ativa por partida; ao concluir, o servidor ativa a próxima. Tipos novos entram quando uma missão precisar.
3. **Motor de regras genérico** (scripts por dados, condições combináveis). Excessivo para seis missões.

## Decisão proposta

Opção 2.

- Definição da missão em dados no repositório (`game/shared/missions/`), lida pelo servidor. O cliente nunca define nem conclui objetivo.
- Uma missão ativa por partida. `push_mission` passa a levar o id da missão e a lista de progresso por objetivo.
- Ação nova de entrega (`request_deliver(zone_id)`), validada como a coleta: posição do servidor, alcance, o jogador carrega o item, intervalo mínimo.
- Conclusão idempotente, registrada uma única vez com a contribuição por jogador. Recompensa e histórico continuam fora (Fases 3 e 4): o servidor só emite o resultado.
- Reinício e encerramento de partida ficam para uma issue própria.

## Consequências

- A missão 1 é reescrita como dados, sem mudar o comportamento (os testes dela passam a ser o teste de regressão).
- Pontos de checkpoint e tempo limite não entram agora.
- Se uma missão pedir um objetivo fora dos tipos fixos, nova decisão (ou nova alternativa 3).
