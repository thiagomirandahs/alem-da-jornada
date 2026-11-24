# ADR-0002: Godot 4 com GDScript como engine e linguagem do jogo

- **Status:** Aceito
- **Data:** 2026-11-24

## Contexto

O jogo é 3D, cooperativo, para Windows e Android, e precisa de um servidor de partidas sem interface gráfica. A equipe é pequena e o projeto não deve depender de licenças com custo por instalação ou receita.

## Alternativas

1. **Unity (C#):** ecossistema grande; licença comercial e histórico de mudanças de termos.
2. **Unreal (C++/Blueprints):** gráficos de ponta; pesado para Android de entrada e para servidores pequenos.
3. **Godot 4 com C#:** mesma engine, mas exportação Android com C# é menos madura que GDScript.
4. **Godot 4 com GDScript:** licença MIT, editor leve, exportação Windows/Android e modo `--headless` com o mesmo código.

## Decisão

Godot 4 com GDScript, na versão fixada em `versions.env` (atualmente **4.7.2-stable**, edição padrão).

- Tipagem estática obrigatória no GDScript.
- Atualização de versão da engine somente por PR, com o projeto aberto e testado na nova versão.

## Consequências

- Cliente e servidor podem compartilhar código (`game/shared/`).
- GDScript é mais lento que C# ou C++ em lógica pesada. O custo de CPU do servidor por partida deve ser **medido** na Fase 2 antes de qualquer meta de escala.
- Testes automatizados em GDScript dependem de ferramenta externa (ex.: GUT), a ser escolhida e registrada na Fase 1.
