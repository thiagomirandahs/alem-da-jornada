# Além da Jornada

Jogo 3D cooperativo e educativo, inspirado em princípios e histórias bíblicas, para Desbravadores cadastrados e autorizados. Plataformas: Windows e Android. Engine: Godot 4 (GDScript), com servidores dedicados e autoritativos.

O plano completo está em [docs/PLANO_MESTRE.md](docs/PLANO_MESTRE.md).

## Status

**Fase 1 — Protótipo 3D, com a fundação de rede.** Personagem com movimento e câmera em terceira pessoa no PC, e um servidor autoritativo (headless) com vários clientes e uma interação validada pelo servidor (cesto de grãos). No Android, há APK de debug com tela de conexão e controles de toque, testado em um aparelho ([relatório](docs/testing/relatorio-android.md)). Cenário do Egito e predição de movimento no cliente ainda não existem.

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

## Android (APK de debug)

**Preparação, uma vez**, sem administrador e sem mexer no PATH. Versões e checksums em [versions.env](versions.env) (`ANDROID_*` e `GODOT_TEMPLATES_SHA512`); **confira cada arquivo contra o checksum antes de extrair**.

| O quê | Para quê | Onde pôr |
|---|---|---|
| Java 17, Temurin (`OpenJDK17U-jdk_x64_windows_hotspot_<ANDROID_JDK_VERSION>.zip`, no GitHub do Adoptium) | `keytool` e `apksigner` | `%LOCALAPPDATA%\Programs\Temurin\` |
| `platform-tools_r37.0.3-win.zip` (`dl.google.com/android/repository/`) | `adb` | `%LOCALAPPDATA%\Android\Sdk\` (cria `platform-tools\`) |
| `build-tools_r36.1_windows.zip` (mesmo lugar) | `apksigner` | a pasta `android-16` do zip vira `%LOCALAPPDATA%\Android\Sdk\build-tools\36.1.0\` |
| `Godot_v4.7.2-stable_export_templates.tpz` (1,28 GB, GitHub do Godot) | APK base | extrair só `templates/android_*` e `templates/version.txt` para `%APPDATA%\Godot\export_templates\4.7.2.stable\` |

O Android SDK tem licença própria ([developer.android.com/studio/terms](https://developer.android.com/studio/terms)). Depois, no editor, em **Editor → Configurações do Editor → Exportar → Android**, aponte o *Java SDK Path* e o *Android SDK Path*. A chave de debug o Godot cria sozinho em `%APPDATA%\Godot\keystores\`, **fora do repositório; nenhuma chave entra no repositório**. A exportação padrão (modelo pré-compilado) não precisa de NDK, CMake nem Gradle.

**Exportar e instalar** (celular com *Depuração USB* ligada):

```bash
godot --headless --path game --export-debug "Android" ../build/alem-da-jornada-debug.apk
adb install -r build/alem-da-jornada-debug.apk
```

**Jogar do celular contra o servidor do PC (rede local).** O servidor **não tem autenticação**: só em rede local de confiança, só durante o teste, e nunca exposto à internet. Escute apenas no endereço do PC nessa rede (não em `0.0.0.0`) e, na tela de conexão do app, digite `ip:7777`:

```bash
godot --headless --path game res://server/server_world.tscn -- --bind=192.168.0.10
```

O firewall do Windows pode pedir permissão para a porta UDP, e **essa decisão é de quem usa o PC**. Redes que o Windows classifica como "Pública" costumam bloquear conexões de entrada.

O app pede só a permissão de internet. Os controles de toque (joystick à esquerda, arrastar à direita para girar a câmera, botão *Interagir*) aparecem no Android; no PC, `--touch` os mostra para conferir o layout.

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
