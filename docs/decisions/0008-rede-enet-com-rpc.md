# ADR-0008: Rede com ENet e RPC do Godot, servidor dono do estado

- **Status:** Aceito (ao mesclar o PR que o introduz)
- **Data:** 2026-11-24

## Contexto

O ADR-0003 define servidor autoritativo. Falta escolher como cliente e servidor conversam. Requisitos: funcionar em Windows e Android, rodar no servidor headless, não deixar o cliente decidir nada oficial e ter poucas peças para manter.

## Alternativas

1. **ENet (UDP) com `@rpc` do Godot, mensagens escritas por nós.** Transporte padrão da engine, funciona em Android, sem dependência.
2. **WebSocket.** Atravessa proxies, mas é TCP: um pacote perdido atrasa todos os seguintes, ruim para movimento.
3. **`MultiplayerSynchronizer` e `MultiplayerSpawner`.** Replicam propriedades sozinhos, mas o cliente passa a "empurrar" estado para o servidor com facilidade e a validação fica espalhada.
4. **Tempo real do Nakama (relay de partida).** Adia o servidor dedicado, que é justamente o que o ADR-0003 quer comprovar.

## Decisão

Opção 1.

- Um nó `Session` (`game/shared/session.gd`), no mesmo caminho (`/root/Game/Session`) no servidor e nos clientes, concentra **todas** as mensagens. Nenhuma outra classe declara `@rpc`.
- **Cliente → servidor:**
  - `send_input(move, yaw)`, não confiável e ordenado: só direção e giro da câmera. A posição nunca é enviada.
  - `request_collect(id)`, confiável: pedido de interação.
- **Servidor → clientes:**
  - `push_state(tick, players)`, não confiável e ordenado, uma vez por tick de física (60 Hz): posições oficiais.
  - `push_collected(id, by)` e `push_denied(id, reason)`, confiáveis.
- O servidor identifica quem enviou por `multiplayer.get_remote_sender_id()`, nunca por campo da mensagem. Os argumentos são `Variant` e validados (tipo, número finito, tamanho) antes de qualquer uso. Mensagem inválida é descartada.
- O servidor simula cada jogador com `CharacterBody3D` e a regra `Movement.step`, a mesma do cliente offline. Com `server_relay` desligado, clientes não enviam mensagens uns aos outros.
- Máximo de 8 jogadores por servidor. Porta padrão 7777, escuta em `127.0.0.1` a menos que `--bind=` diga o contrário.

## Consequências

- **Sem predição:** o cliente só mostra o que o servidor manda. Em localhost o atraso não aparece; com rede real o personagem responderá com o atraso da ida e volta. Predição entra em issue própria, depois de medir.
- **Sem autenticação nem criptografia:** qualquer um que alcance a porta entra. Isto vale só para desenvolvimento; antes de expor em rede, a Fase 3 deve ligar o token de sessão do Nakama ao servidor, e DTLS deve ser avaliado.
- Produção exigirá porta UDP aberta no firewall.
- Todo contrato novo (mensagem, argumento) é alterado em um único arquivo, `session.gd`, e deve ter validação e teste.
