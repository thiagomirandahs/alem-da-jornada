# Além da Jornada

Jogo 3D cooperativo e educativo, inspirado em princípios e histórias bíblicas, para Desbravadores cadastrados e autorizados. Plataformas: Windows e Android. Engine: Godot 4 (GDScript), com servidores dedicados e autoritativos.

O plano completo está em [docs/PLANO_MESTRE.md](docs/PLANO_MESTRE.md).

## Status

**Fase 0 — Governança e fundação.** Ainda não existe código de jogo. O projeto Godot começa na Fase 1.

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

Depois, leia [CONTRIBUTING.md](CONTRIBUTING.md) antes de abrir a primeira issue.

## Estrutura atual

```text
.github/            Templates de issue e PR, CI e Dependabot
docs/
  PLANO_MESTRE.md   Plano de desenvolvimento (fonte de referência)
  decisions/        ADRs (decisões arquiteturais)
AGENTS.md           Regras para agentes de IA
CONTRIBUTING.md     Processo de contribuição e convenções
SECURITY.md         Processo de segurança
versions.env        Versões fixadas
```

Os diretórios `game/`, `backend/`, `database/`, `infra/` e `tests/` (PLANO_MESTRE §4) serão criados quando cada módulo for implementado.

## Documentação

- [Plano mestre](docs/PLANO_MESTRE.md)
- [Decisões arquiteturais (ADRs)](docs/decisions/)
- [Contribuição](CONTRIBUTING.md)
- [Segurança](SECURITY.md)
- [Regras para agentes de IA](AGENTS.md)
