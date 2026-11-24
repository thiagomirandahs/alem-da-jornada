# ADR-0003: Servidor de partidas dedicado e autoritativo

- **Status:** Aceito
- **Data:** 2026-11-24

## Contexto

As partidas concedem progresso e recompensas, e os jogadores são crianças e adolescentes de diferentes clubes. Se o cliente puder decidir resultados, qualquer cliente modificado consegue fraudar missões e recompensas.

## Alternativas

1. **Cliente autoritativo:** simples, mas qualquer cliente modificado frauda resultados.
2. **Peer-to-peer / host jogador:** sem custo de servidor, mas o host pode trapacear e há problemas de NAT entre redes domésticas e móveis.
3. **Servidor dedicado autoritativo (Godot headless):** custo de infraestrutura, mas o estado oficial fica fora do alcance do jogador.

## Decisão

Cada partida roda em um servidor Godot headless dedicado, dono do estado oficial.

- O cliente envia apenas **comandos** (mover, interagir, coletar, transportar, construir, usar recurso).
- O servidor valida identidade, participação, distância, posição, disponibilidade do objeto, regras da missão, limites de velocidade e frequência e estado da partida.
- O cliente apenas apresenta o estado recebido (interpolação e, se necessário, predição local que o servidor corrige).
- Resultados e recompensas são enviados pelo servidor ao backend, nunca pelo cliente.

## Consequências

- Custo de servidor por partida ativa: precisa ser medido (Fase 2) e orçado (Fase 5).
- A latência afeta a resposta da movimentação; predição e interpolação no cliente entram no escopo da Fase 2.
- O servidor precisa de credencial própria para o backend, com permissões mínimas (sem acesso administrativo ao banco).
