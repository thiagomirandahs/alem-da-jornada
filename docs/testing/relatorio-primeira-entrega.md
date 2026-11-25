# Relatório da primeira entrega

**Data:** 2026-11-24 · **Referência:** PLANO_MESTRE §14 (item 12) · **Issues:** #1, #3 e #5 · **Godot:** 4.7.2

Este relatório separa o que foi **medido** do que é **estimado** e do que **não foi testado**. Onde há suposição, ela está dita.

## Resumo

- A fundação técnica funciona: servidor Godot headless autoritativo, dois ou mais clientes na mesma partida e uma interação (coletar um cesto) decidida pelo servidor.
- Os testes automatizados passam e foram conferidos por mutação: quebrar a regra de propósito derruba o teste.
- Uma partida de 8 jogadores custou, no hardware de desenvolvimento, cerca de **10,6% de um núcleo**, **86 MB de memória** e **102 kB/s de saída de rede**. O servidor manteve 60 ticks por segundo em todas as medições.
- O tráfego de saída cresce com o **quadrado** do número de jogadores, e cada partida paga um custo fixo de processo (≈5% de um núcleo e ≈86 MB).
- Com a suposição de pico do ADR-0006 (50 a 100 partidas simultâneas), a conta **não cabe em 1 ou 2 VPS pequenas**. Isso foi registrado no [ADR-0009](../decisions/0009-dimensionamento-a-partir-da-medicao.md). A maior incerteza continua sendo o pico real de jogadores, que ainda não foi medido.
- Pendências importantes: a tecla E em cliente real por uma pessoa não tem evidência; Android, rede com latência real e a medição em uma VPS ainda não foram feitos.

## 1. O que foi testado

| Teste | Como | Resultado |
|---|---|---|
| Unitários | `godot --headless --path game -s res://tests/run.gd` | **22 passaram, 0 falharam** (Windows, local). Cobrem movimento, entrada de rede malformada, regra de coleta, argumentos, estatísticas e carregamento das cenas |
| CI | GitHub Actions, Linux | Verde na `main` no commit `0db6bc7` (inclui a verificação de segredos) |
| Rede (integração) | `game/tests/integration/run.sh`: servidor + 2 clientes em script, sem janela | **Passou**, local e no CI. De longe a coleta é recusada; de perto é aceita; recoleta e objeto inexistente são recusados; vetor de entrada gigante não passa da velocidade máxima; NaN, tipos errados e id de 1000 caracteres são ignorados sem derrubar o servidor; a saída de um cliente não derruba o servidor |
| Limite de jogadores | 9 conexões contra um servidor | **8 entram, a 9ª é recusada** |
| Mutações | Quebrar a regra de propósito e rodar o teste de rede | Sem limite de velocidade, sem checagem de distância, sem checagem de "já coletado" e com 100 vagas: **cada uma derrubou o teste**, com mensagem clara. Código restaurado depois |
| Cliente real, por script | Cena `net_client.tscn` conduzida por script | Conecta, cria avatar e câmera; E de longe mostra no HUD "Servidor recusou a coleta de Basket: longe", igual ao log do servidor |
| Servidor encerrando sozinho | `--quit-after`, com e sem cliente conectado | Código 0, sem erros |
| Jogo à mão, PC (PR #2) | Uma pessoa jogou | Movimento, câmera e colisão confirmados pelo autor |
| Jogo à mão, rede (PR #4) | Servidor e 2 janelas, uma pessoa | Autor respondeu que **funcionou**. O log do servidor registrou a entrada dos 2 jogadores e **nenhuma tentativa de coleta** |

## 2. O que não foi testado

- **Tecla E em cliente real por uma pessoa.** Só há evidência por script (evento de tecla simulado). Na partida manual o log não registrou nenhuma tentativa.
- **Android** (nenhum build nem controle de toque).
- **Rede fora do próprio PC** e **latência real**: tudo rodou em `127.0.0.1`. Não há predição no cliente, então com latência o personagem responde com atraso.
- **Reconexão**, **várias partidas** em um servidor e **vários servidores**.
- **Partidas longas**: as medições duram 60 s cada.
- **O script de medição em Linux** só foi exercitado pelo CI de fumaça (ver §3).
- **Segurança de rede além dos casos acima**: não houve teste de abuso de volume, de conexões lentas nem de pacotes forjados.

## 3. Medição de carga (medido)

### Método

`game/tests/performance/run.sh`, issue #5. Sobe o servidor com `--stats` e N clientes que andam (1 mensagem de entrada por tick, direção nova a cada segundo, voltando ao centro se passarem de 15 m). Em cada execução: espera todos entrarem, mais 5 s de aquecimento, e mede **60 s**. Cada cenário foi repetido **3 vezes**.

- **Por fora:** CPU do processo do servidor (tempo de CPU na janela ÷ tempo real, em % de **um** núcleo) e memória (working set).
- **Por dentro (`--stats`, janelas de 5 s):** ticks por segundo, tempo do `_physics_process` do servidor e bytes enviados e recebidos pelo ENet.

**Máquina:** notebook Intel Core i5-5200U (2 núcleos, 4 threads, 2,2 GHz, de 2015), 12 GB de RAM, Windows 10, plano de energia "Alto desempenho". **Servidor e todos os clientes rodaram na mesma máquina.** Execução de 20:48 a 21:03. O uso do computador durante a medição **não foi controlado**.

### Resultados (mediana das 3 execuções; entre parênteses, o pior caso)

| Jogadores | CPU (% de 1 núcleo) | Memória (MB) | Ticks/s | Tick p95 (ms) | Tick máximo (ms) | Saída (kB/s) | Entrada (kB/s) |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | 5,0 (5,5) | 85,7 | 60,0 | 0,24 | 18,5 | 2,9 | 2,0 |
| 2 | 5,6 (6,5) | 85,7 | 60,0 | 0,34 | 37,1 | 8,6 | 4,0 |
| 4 | 5,6 (6,9) | 85,7 | 60,0 | 0,46 | 30,4 | 28,5 | 8,1 |
| 8 | 10,6 (12,0) | 85,9 | 60,0 | 0,78 | **534,8** | 102,0 | 16,2 |

"Tick p95": em cada execução, mediana dos p95 das janelas de 5 s; na tabela, a mediana entre as 3 execuções. "Tick máximo": o maior valor visto nas 3 execuções. kB = 1024 bytes.

### O que os números dizem

- **60 ticks por segundo em todas as execuções.** O tempo típico do tick é pequeno (p95 abaixo de 1 ms, de um orçamento de 16,7 ms).
- **CPU:** de 1 a 4 jogadores a diferença fica dentro do ruído (4,7% a 6,9%). Com 8 jogadores sobe para ≈10,6%. Há um custo fixo de ≈5% de um núcleo só por o processo existir.
- **Memória:** ≈86 MB por processo, praticamente igual com 1 ou 8 jogadores. É o custo do motor, não dos jogadores. (A memória estática do próprio motor, impressa por `--stats`, é ≈25 MB.)
- **Rede:** a saída cresce com o quadrado dos jogadores (2,9 → 8,6 → 28,5 → 102 kB/s), porque cada estado de 60 Hz leva as posições de **todos** para **todos**. Com 8 jogadores, cada estado tem ≈218 bytes. A entrada cresce linearmente (≈2 kB/s por jogador).
- **Uma pausa de 535 ms** apareceu numa execução com 8 jogadores (execuções 1 e 2 do mesmo cenário tiveram no máximo 7,3 e 2,5 ms). A causa **não foi investigada**: a máquina tinha 9 processos disputando 2 núcleos. Se acontecer em uma VPS, é um problema real (os jogadores veriam a tela travar).

### Limitações da medição

- Hardware de 2015, em Windows, com os clientes na mesma máquina. O tempo de CPU do processo é pouco afetado por essa disputa; o **tempo de tick** e os picos são afetados.
- Partidas sintéticas: os jogadores só andam. Sem coleta, sem missão, sem entrada e saída de jogadores.
- 60 s por execução, 3 execuções. Não mostra vazamento de memória nem comportamento de longa duração.

## 4. Estimativa (não medido)

Suposições, todas **herdadas do ADR-0006 e sem dado real**: o pico é de 10% a 20% das 4.000 contas, ou seja, 400 a 800 jogadores, em **50 a 100 partidas** de 8. Usa-se o custo medido de uma partida de 8 e uma meta de **60% de uso de CPU** para sobrar folga para picos.

| | 50 partidas | 100 partidas |
|---|---:|---:|
| Jogadores | 400 | 800 |
| Núcleos de CPU (10,6% por partida ÷ 60%) | ≈ 8,8 | ≈ 17,7 |
| VPS de 4 vCPU necessárias | 3 | 5 |
| Memória só dos servidores de partida (86 MB cada) | ≈ 4,3 GB | ≈ 8,6 GB |
| Saída de rede (102 kB/s por partida) | ≈ 42 Mbit/s | ≈ 84 Mbit/s |
| Tráfego de saída por hora de pico | ≈ 18 GB | ≈ 35 GB |

Cada partida de 8 jogadores gera ≈ 0,35 GB de saída por hora.

**Isto não inclui** o Nakama, o PostgreSQL, o sistema operacional e a folga de memória. **A velocidade de um núcleo de VPS é desconhecida:** pode ser bem maior que a deste notebook de 2015, e isso reduziria os números de CPU. Só a medição na VPS escolhida resolve.

## 5. Conclusões

1. A arquitetura do ADR-0003 funciona: o servidor sustenta o estado oficial e os testes provam que o cliente não decide nada.
2. O custo por partida é viável, mas o dimensionamento do ADR-0006 ("1 ou 2 VPS") deve ser **retirado**. O [ADR-0009](../decisions/0009-dimensionamento-a-partir-da-medicao.md) registra isso e o que fazer antes de contratar servidores.
3. K3s e Agones continuam adiados: os números pedem **mais servidores** ou **menor custo por partida**, não um orquestrador.
4. O que mais move a conta é o número real de jogadores simultâneos, que ainda é uma suposição.

## 6. Como reproduzir

```bash
godot --headless --path game --import
GODOT=/caminho/do/godot bash game/tests/performance/run.sh 60 3 "1 2 4 8"   # ≈ 15 min
GODOT=/caminho/do/godot bash game/tests/integration/run.sh                    # ≈ 15 s
godot --headless --path game -s res://tests/run.gd
```
