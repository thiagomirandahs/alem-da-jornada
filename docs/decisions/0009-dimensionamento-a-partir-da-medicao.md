# ADR-0009: Dimensionamento a partir da primeira medição

- **Status:** Aceito (ao mesclar o PR que o introduz)
- **Data:** 2026-11-24
- **Complementa:** [ADR-0006](0006-infraestrutura-proporcional-a-medicao.md)

## Contexto

O ADR-0006 estimou, sem dados, que 1 ou 2 VPS bastariam para o pico (50 a 100 partidas simultâneas) e adiou K3s e Agones até haver medição. A primeira medição (`docs/testing/relatorio-primeira-entrega.md`) deu, para uma partida de 8 jogadores, em um notebook de 2015 com os clientes na mesma máquina:

- ≈ 10,6% de um núcleo, ≈ 86 MB de memória e ≈ 102 kB/s de saída de rede;
- custo fixo de ≈ 5% de um núcleo e ≈ 86 MB por processo, mesmo com 1 jogador;
- saída de rede crescendo com o quadrado dos jogadores;
- 60 ticks por segundo mantidos, mas uma pausa de 535 ms vista uma vez.

Na suposição de pico do ADR-0006, isso dá cerca de 9 a 18 núcleos (a 60% de uso), 4 a 9 GB de memória e 42 a 84 Mbit/s de saída só para os servidores de partida: de 3 a 5 VPS de 4 vCPU. A estimativa de "1 ou 2 VPS" não se sustenta com esses números.

## Alternativas

1. **Adotar K3s e Agones já.** Resolve a orquestração de muitos servidores, mas o problema medido é de custo por partida e de número de máquinas, não de orquestração. Um alocador simples escolhe entre poucas VPS.
2. **Manter o ADR-0006 e a estimativa de 1 ou 2 VPS.** Contraria os números medidos.
3. **Manter a arquitetura do ADR-0006, retirar o dimensionamento e exigir novos dados antes de contratar servidores.**

## Decisão

Opção 3.

- Continua valendo o ADR-0006: um processo Godot headless por partida, alocador simples, sem K3s e Agones por ora.
- A estimativa de **"1 ou 2 VPS" está retirada**. O dimensionamento passa a partir do custo por partida (CPU, memória e rede, como no relatório) e do pico real.
- **Antes de contratar servidores**, fazer, cada item em issue própria:
  1. repetir a medição na VPS candidata (o núcleo dela pode ser bem mais rápido ou mais lento que o do notebook);
  2. obter uma estimativa real de jogadores simultâneos no pico (por exemplo, com os clubes), no lugar dos 10% a 20% supostos;
  3. avaliar, **medindo cada uma**, as alavancas de custo: taxa de estados menor que 60 Hz, posições compactas, exportação "Dedicated Server" do Godot e várias partidas por processo;
  4. investigar a pausa de 535 ms se ela se repetir.

### Gatilhos para rever (acrescentam-se aos do ADR-0006)

Valores iniciais, a ajustar com dados da VPS:

- ticks por segundo abaixo de 59, de forma sustentada, ou tempo de tick no p95 acima de 5 ms (30% do orçamento de 16,7 ms);
- qualquer pausa de tick acima de 100 ms em partida normal;
- previsão de mais de 5 VPS: avaliar orquestração (K3s e Agones) com novo ADR.

## Consequências

- O custo de infraestrutura pode ser maior que o imaginado no início; isso aparece agora, não no lançamento.
- Nenhuma otimização é decidida aqui. Só se escolhe o que medir antes.
- Mais de uma partida por processo, se adotada, muda o ADR-0006 e exige novo ADR.
