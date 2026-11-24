# ADR-0006: Infraestrutura proporcional à carga medida

- **Status:** Aceito
- **Data:** 2026-11-24

## Contexto

O plano previa K3s, Agones, Prometheus, Grafana e Loki, além de testes com 4.000 e 5.000 jogadores. Mas 4.000 **contas** não significam 4.000 jogadores **simultâneos**.

Estimativa inicial, **sem dados reais**: pico de 10% a 20% das contas em dia de reunião de clube, ou seja, 400 a 800 jogadores, em 50 a 100 partidas de 8. O próprio plano diz que nenhuma capacidade de escala é declarada sem medição; a regra vale também para a infraestrutura de escala.

## Alternativas

1. **K3s + Agones + observabilidade completa desde o início:** preparado para escala alta, mas com custo de operação e de aprendizado antes de existir carga.
2. **Processos em VPS com alocador simples, crescendo conforme a medição.**

## Decisão

Opção 2.

- **Partidas:** um processo Godot headless por partida, em 1 ou 2 VPS. Um alocador mínimo, chamado quando o matchmaking do Nakama forma um grupo, inicia o processo numa VPS com capacidade livre. O desenho do alocador será feito em ADR na Fase 2 ou 5.
- **Observabilidade:** métricas do Nakama, contadores do servidor de partidas e logs dos containers. Prometheus, Grafana e Loki entram só se a operação pedir.
- **Testes de desempenho:** primeiro, medir o custo de **uma** partida de 8 jogadores (CPU, RAM, banda) na Fase 2. A capacidade vem dessa medida; o teste de carga é feito no pico estimado e em 1,5 vez esse pico.
- **K3s e Agones** só entram com novo ADR, se a medição mostrar que as VPS não bastam ou que alocar à mão virou gargalo.

## Gatilhos para rever esta decisão

- Pico medido ou previsto acima da capacidade de 2 VPS.
- Evento com todos os clubes jogando ao mesmo tempo.
- Falhas de alocação ou de recuperação que o alocador simples não resolva.

## Consequências

- Menos componentes para operar até existir carga real.
- Se o pico real for muito maior que a estimativa, haverá migração para orquestração. O servidor de partidas roda em container desde o início para que essa migração não exija reescrita.
