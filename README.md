# Além da Jornada

Jogo 3D cooperativo e educativo, inspirado em princípios e histórias bíblicas, para Desbravadores cadastrados e autorizados. Plataformas: Windows e Android. Engine: Godot 4 (GDScript), com servidores dedicados e autoritativos.

O plano completo está em [docs/PLANO_MESTRE.md](docs/PLANO_MESTRE.md).

## Status

**Fase 1 — Protótipo 3D, com a fundação de rede.** Personagem com movimento e câmera em terceira pessoa no PC, e um servidor autoritativo (headless) com vários clientes e uma interação validada pelo servidor (cesto de grãos). Controles de Android, cenário do Egito e predição de movimento no cliente ainda não existem.

## Requisitos do ambiente

| Ferramenta | Versão | Observação |
|---|---|---|
| Git | 2.40 ou superior | |
| Godot | definida em [versions.env](versions.env) | Baixar a versão **exata** em godotengine.org (edição padrão, não a .NET) |

As versões fixadas ficam em [versions.env](versions.env). Nenhuma versão é alterada fora de um Pull Request.

## Primeiros passos

```bash
git clone <url-do-repositorio> alem-da-jornada
cd alem-da-jornada
```

**Abrir e jogar:** no Godot, "Importar" → selecione `game/project.godot` → F5.

| Ação | Teclado e mouse |
|---|---|
| Andar | W A S D ou setas |
| Girar a câmera | Clique na tela para capturar o mouse e mova-o |
| Liberar o mouse | Esc |

**Rodar os testes** (use o executável `_console` no Windows para ver a saída):

```bash
godot --headless --path game --import
godot --headless --path game -s res://tests/run.gd
```

**Jogar em rede (no mesmo PC):** um servidor e quantos clientes quiser (até 8), cada um em seu terminal. O servidor escuta só em `127.0.0.1` e **não tem autenticação**; não o exponha na internet ([ADR-0008](docs/decisions/0008-rede-enet-com-rpc.md)).

```bash
godot --headless --path game res://server/server_world.tscn
godot --path game res://client/scenes/net_client.tscn -- --connect=127.0.0.1:7777
```

Opções do servidor, depois de `--`: `--port=7777` e `--bind=127.0.0.1`. No cliente, **E** coleta o cesto de grãos mais próximo: o servidor só aceita se você estiver a até 2,5 m e ninguém o tiver coletado.

**Teste de rede** (servidor e clientes em script, sem janela; `GODOT` aponta para o executável):

```bash
GODOT=/caminho/do/godot bash game/tests/integration/run.sh
```

**Medição de carga** (servidor com `--stats` e N clientes que andam; leva uns 15 min com os valores padrão). Resultados e método em [docs/testing/](docs/testing/):

```bash
GODOT=/caminho/do/godot bash game/tests/performance/run.sh [segundos=60] [repetições=3] ["jogadores"="1 2 4 8"]
```

Leia [CONTRIBUTING.md](CONTRIBUTING.md) antes de abrir a primeira issue.

## Estrutura atual

```text
game/               Projeto Godot
  client/           Cenas e scripts do cliente (offline e de rede)
  server/           Servidor headless da partida
  shared/           Regras e mensagens usadas por cliente e servidor (movimento, interação, Session)
  tests/            Executor, testes unitários, teste de rede e medição de carga (ADR-0007, ADR-0008)
.github/            Templates de issue e PR, CI e Dependabot
docs/
  PLANO_MESTRE.md   Plano de desenvolvimento (fonte de referência)
  decisions/        ADRs (decisões arquiteturais)
AGENTS.md           Regras para agentes de IA
CONTRIBUTING.md     Processo de contribuição e convenções
SECURITY.md         Processo de segurança
versions.env        Versões fixadas
```

Os diretórios `backend/`, `database/` e `infra/` (PLANO_MESTRE §4) serão criados quando cada módulo for implementado. Os testes do jogo ficam dentro de `game/tests/`, porque o Godot só carrega scripts de dentro do projeto.

## Documentação

- [Plano mestre](docs/PLANO_MESTRE.md)
- [Decisões arquiteturais (ADRs)](docs/decisions/)
- [Contribuição](CONTRIBUTING.md)
- [Segurança](SECURITY.md)
- [Regras para agentes de IA](AGENTS.md)
