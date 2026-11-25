# Revisão de consistência das oito pranchas

**Data:** 2026-11-24 · **Issue:** #9 · **Status:** feita antes de pedir aprovação; **a aprovação é do autor do projeto e ainda não existe**

Quem revisou foi quem produziu as pranchas. Isso é um viés: uma revisão do próprio autor tende a achar o que já sabia. Por isso há duas camadas: verificações **automáticas**, que não dependem de opinião, e uma revisão **visual**, que depende de quem olha. A pessoa que decide é o autor do projeto.

Imagens: [`pranchas/`](pranchas/). Para comparar tudo de uma vez: [`pranchas/00-folha-de-contato.png`](pranchas/00-folha-de-contato.png).

## 1. Verificação automática

`game/tests/unit/test_art_kit.gd`, 5 testes, executados no CI. Constroem todos os modelos do kit (personagens, objetos, natureza, efeitos) e todas as oito pranchas.

| Regra | O que o teste confere |
|---|---|
| Paleta | As cinco cores do guia têm exatamente os hexadecimais do guia. Todo material usa uma cor da paleta, com o valor exato |
| Materiais foscos, sem textura | Rugosidade 1, metal 0, opaco e sem imagem. Só os efeitos podem ser translúcidos, e só com o material de efeito do kit |
| Mesma geometria | Toda malha veio do `LowPoly` (caixas e prismas de faces planas) |
| Orçamento de triângulos | Personagem ≤ 2.000, árvore ≤ 400, objeto ≤ 300, efeito ≤ 600 |
| Mesmo cabeçalho e mesma luz | Toda prancha tem o cabeçalho padrão. Se tem sol próprio, ele é idêntico a uma das quatro situações do `Stage` |

**Os testes conseguem falhar.** Duas mutações, depois revertidas: um material brilhante (derrubou o teste de materiais) e uma prancha com luz própria (derrubou o teste de luz).

Medido: o personagem masculino tem 624 triângulos e o feminino, 696, bem abaixo do limite.

## 2. Revisão visual: regras da seção 9 do guia

| Regra | Resultado | Observação |
|---|---|---|
| Todos os modelos compartilham o mesmo estilo de geometria | **Atende** | Tudo é bloqueado e facetado. Exceção intencional: os ícones da interface (prancha 7) são 2D, feitos de retângulos, triângulos e octógonos, na mesma família |
| Proporções coerentes entre personagens e objetos | **Atende, com ressalva** | A prancha 5 mostra a escala real: Desbravador 1,5 m, barraca ≈ 1,25 m, caixa 0,45 m. Ressalva: árvores e animais não estão na régua de escala |
| Não misturar low-poly com realismo | **Atende** | Sem textura nem imagem em nenhum modelo |
| Não variar aleatoriamente iluminação e materiais | **Atende** | O material é um só por cor. A luz tem quatro situações definidas em `Stage`: estúdio (pranchas 1, 2, 4, 5, 6), manhã (3 e HUD da 7) e as quatro lado a lado na 8 |
| Preservar a identidade entre cenários | **Não dá para afirmar** | Só existe um cenário, o acampamento. Cavernas, ruínas, floresta tropical e montanhas jogáveis ainda não foram feitos |
| Evitar excesso de detalhes pequenos | **Atende, com ressalva** | Os rostos e objetos têm detalhes de poucos centímetros. Na folha de contato eles somem; só aparecem de perto. A floresta da prancha 3 é densa |
| Não usar elementos copiados de jogos existentes | **Não verificado por ferramenta** | O desenho é original, mas o estilo bloqueado lembra outros jogos do gênero. Recomendo que o autor olhe com esse critério |

### O que parece de um mesmo jogo

- Cabeçalho, tipografia e faixa de cores iguais nas oito.
- Os mesmos personagens, objetos e plantas aparecem em várias pranchas, inclusive dentro do HUD da prancha 7 e da luz da prancha 8.
- A mesma paleta, com o lenço amarelo como acento recorrente.

### Desvios encontrados e corrigidos durante a produção

| Desvio | Correção |
|---|---|
| Luz estourada: o marrom `#B1611F` saía laranja vivo e a areia, branca | Luz calibrada **medindo pixels**: a areia sai `#E6DFC8` (paleta `#E5DBC6`) |
| Prismas "do avesso" e sem tampa | Sentido das faces corrigido no `LowPoly`, para todos de uma vez |
| Lenço apontando de lado e colarinho invisível | Corrigido no personagem |
| Sombra sobre o rosto nas fichas | Luz de estúdio quase frontal, definida no `Stage` |
| Bota com cano saindo atrás das pernas | Cano ajustado dentro da perna |
| Barraca tão alta quanto o personagem | Barraca baixada para ≈ 1,25 m |
| Rio invisível (a água ficava na mesma altura do chão) e céu coberto pela névoa | Água e margens elevadas, e a névoa deixou de pintar o céu |
| Três luzes parecidas na prancha 8 | Céu e sol próprios de cada situação, com os mesmos materiais |
| Prancha 6 com fundos quase pretos, destoando das outras | Fundos em cinza médio da própria paleta, sem sombras vizinhas |

## 3. O que fica para o autor decidir

1. **Cores complementares e cores do uniforme** são propostas minhas. O guia só fixa o lenço (amarelo com acabamento vermelho). Confira com o uniforme oficial dos Desbravadores.
2. **A prancha 3 não é uma ficha:** é uma cena completa, com o mesmo kit. Julguei isso adequado ao "cenário completo" do guia.
3. **Expressão do rosto:** só existe um sorriso. O guia pede "expressivo"; há pouca variedade.
4. **Animais** são três e bem simples. **Tipografia** é a fonte padrão do Godot, não uma escolha de design.
5. **Poucos ambientes:** falta dar o mesmo tratamento a cavernas, ruínas, floresta tropical e áreas de desafio.
6. **O nível de acabamento:** formas montadas por código dão um estilo bloqueado simples. Se o autor quiser algo mais refinado, a produção deve passar por um artista 3D, seguindo este kit.

## 4. O que esta revisão não prova

- Que o resultado **agrada** ao autor, nem que atende a visão dele. Só ele diz.
- Que os modelos funcionam **no jogo**, no celular, com animação. Não foram usados no jogo ainda.
- Que as cores aparecem iguais em outras telas. As imagens foram geradas no notebook de desenvolvimento, em OpenGL; o celular usa outro caminho de renderização.
- Que o estilo se sustenta quando o universo crescer. Só um cenário foi feito.

## 5. Como regenerar

```bash
godot --headless --path game --import
godot --path game -s res://art/render_boards.gd        # precisa de janela (GPU); grava em docs/art/pranchas/
godot --headless --path game -s res://tests/run.gd     # inclui a verificação de consistência
```
