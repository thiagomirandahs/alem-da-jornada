# Além da Jornada

Jogo 3D cooperativo e educativo, inspirado em princípios e histórias bíblicas, para Desbravadores cadastrados e autorizados. Plataformas: Windows e Android. Engine: Godot 4 (GDScript), com servidores dedicados e autoritativos.

O plano completo está em [docs/PLANO_MESTRE.md](docs/PLANO_MESTRE.md).

## Status

**Fase 1 — Protótipo 3D.** Personagem com movimento e câmera em terceira pessoa num cenário de teste (PC). Controles de Android, cenário do Egito e interações ainda não existem.

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

Leia [CONTRIBUTING.md](CONTRIBUTING.md) antes de abrir a primeira issue.

## Estrutura atual

```text
game/               Projeto Godot
  client/           Cenas e scripts do cliente
  shared/           Regras usadas por cliente e servidor (ex.: movimento)
  tests/            Executor e testes automatizados (ADR-0007)
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
