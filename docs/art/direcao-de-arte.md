# Além da Jornada: guia de direção de arte

**Status:** pranchas produzidas e revisadas, **aguardando aprovação do autor** · **Issue:** #9 · Revisão: [revisao-de-consistencia.md](revisao-de-consistencia.md)

Os universos históricos de José (Egito) e Daniel (Babilônia) têm guia próprio: [guia-jose-daniel.md](guia-jose-daniel.md). Os dois se encontram no mesmo kit (`game/art/`).

Este documento tem duas partes:

1. **Guia do autor** (seções 1 a 10), mantido como foi enviado.
2. **Decisões desta etapa** (seção 11), que são **propostas** de quem produziu as pranchas e **precisam ser aprovadas** pelo autor. Onde o guia não define algo, a proposta está aqui, marcada como proposta.

---

## 1. Conceito visual

Criar uma identidade visual própria para Além da Jornada, um jogo 3D de aventura cooperativa para Desbravadores.

A estética deve transmitir:

- Aventura e descoberta.
- Natureza e exploração.
- Amizade e cooperação.
- Acampamento e vida ao ar livre.
- Conhecimento e aprendizado.
- Fé e valores cristãos.

O estilo escolhido é **LOW-POLY BLOQUEADO**, com aparência tridimensional estilizada, formas geométricas simplificadas e acabamento visual consistente.

Não queremos realismo fotográfico, estética infantil exagerada ou aparência de jogo de combate.

## 2. Estilo dos personagens

Criar personagens 3D estilizados com:

- Cabeça ligeiramente maior que as proporções humanas reais.
- Corpo compacto e proporções equilibradas.
- Rosto amigável e expressivo.
- Geometria simplificada.
- Roupas com volumes bem definidos.
- Mãos e pés estilizados.
- Modelagem low-poly com acabamento profissional.

Os personagens devem parecer jovens aventureiros, não guerreiros.

### Uniforme

Representar visualmente os Desbravadores:

- Uniforme característico.
- Lenço amarelo com acabamento vermelho.
- Mochila de exploração.
- Calçados apropriados para trilhas.
- Acessórios de acampamento.

Criar variações de aparência, tons de pele, cabelos e personalização, preservando a identidade do uniforme.

## 3. Estilo dos cenários

Os cenários devem ser amplos, bonitos e convidativos à exploração.

Características:

- Árvores geométricas estilizadas.
- Vegetação com diferentes alturas e volumes.
- Montanhas com silhuetas marcantes.
- Rios com água estilizada.
- Pedras e terrenos com formas geométricas.
- Iluminação natural.
- Céu com cores suaves.
- Ambientes com profundidade e diferentes planos visuais.

Evitar cenários vazios ou excessivamente simples.

### Ambientes de referência

1. Acampamento na floresta.
2. Floresta tropical.
3. Montanhas e vales.
4. Rios e cachoeiras.
5. Cavernas.
6. Trilhas e pontes suspensas.
7. Ruínas históricas.
8. Áreas abertas para desafios em equipe.

## 4. Objetos e elementos visuais

Todos os objetos devem seguir a mesma linguagem low-poly:

- Barracas.
- Mochilas.
- Bússolas.
- Mapas.
- Cordas.
- Lanternas.
- Cantis.
- Caixas de equipamentos.
- Pontes de madeira.
- Placas de orientação.
- Árvores e plantas.
- Rochas e formações naturais.
- Animais silvestres.

Os objetos precisam parecer parte do mesmo universo visual dos personagens e ambientes.

## 5. Paleta de cores

Paleta de referência:

| Nome | Cor |
|---|---|
| Marrom | `#B1611F` |
| Vermelho escuro | `#77170C` |
| Verde floresta | `#404F32` |
| Bege areia | `#E5DBC6` |
| Cinza claro | `#F4F5F8` |

Complementar com tons de azul, verde, amarelo e cores naturais para criar ambientes vivos.

Priorizar contraste, harmonia e boa leitura visual.

## 6. Iluminação e acabamento

Adotar:

- Iluminação natural e suave.
- Sombras consistentes.
- Ambientação cinematográfica leve.
- Materiais foscos.
- Texturas discretas.
- Cores bem equilibradas.
- Profundidade atmosférica.
- Boa leitura dos personagens em diferentes ambientes.

A aparência deve lembrar uma produção independente de alta qualidade, com identidade visual marcante.

## 7. Interface visual

Criar uma identidade gráfica que combine com o universo do jogo.

Elementos:

- Menus com aparência de diário de expedição.
- Ícones estilizados.
- Mapas ilustrados.
- Molduras inspiradas em equipamentos de aventura.
- Indicadores de objetivos.
- Painéis de inventário.
- Tipografia de boa legibilidade.
- Botões com formas simples e acabamento consistente.

A interface não deve parecer militar, futurista ou agressiva.

## 8. Pranchas de referência a produzir

1. **Character Design:** personagens masculinos e femininos, com vistas frontal, lateral e traseira.
2. **Uniform Design:** detalhes do uniforme, lenço, mochila e acessórios.
3. **Environment Design:** cenário completo de acampamento na floresta.
4. **Nature Assets:** árvores, plantas, pedras, rios e animais.
5. **Props Design:** objetos e equipamentos de exploração.
6. **Visual Effects:** água, iluminação, poeira, folhas e efeitos ambientais.
7. **UI Design:** menus, mapa, inventário e HUD.
8. **Color & Lighting:** paleta, iluminação e atmosfera dos ambientes.

## 9. Regras de consistência visual

- Todos os modelos devem compartilhar o mesmo estilo de geometria.
- Manter proporções coerentes entre personagens e objetos.
- Não misturar low-poly com realismo fotográfico.
- Não variar aleatoriamente iluminação e materiais.
- Preservar a identidade visual entre diferentes cenários.
- Evitar excesso de detalhes pequenos.
- Não utilizar personagens, cenários ou elementos copiados de jogos existentes.

## 10. Resultado esperado

Criar um universo visual próprio para Além da Jornada, com personagens reconhecíveis, cenários memoráveis, objetos coerentes e interface integrada.

A referência deve ser suficientemente detalhada para orientar a produção de modelos 3D e ilustrações futuras.

**Prioridade: consistência visual acima da quantidade de assets.** Primeiro estabelecer o padrão visual definitivo e depois expandir todo o universo.

---

## 11. Decisões desta etapa (propostas, aguardam aprovação)

### Como as pranchas são feitas

As pranchas **não são ilustrações pintadas**. São **renders do Godot** de modelos low-poly montados por código, todos a partir de **um único kit de estilo** (`game/art/`): paleta, materiais, formas facetadas, iluminação e cabeçalho de prancha. A consistência vem da construção: uma prancha não define cor, material nem luz por conta própria. Os mesmos modelos são a base dos ativos do jogo na etapa seguinte.

Limite honesto: formas montadas por código dão um estilo bloqueado simples. Para um acabamento mais refinado, a produção deve passar por um artista 3D, que segue este kit como padrão.

### Paleta complementar (proposta)

As cinco cores do guia ficam como estão. Estas completam a paleta:

| Uso | Nome | Cor |
|---|---|---|
| Lenço | Amarelo lenço | `#F2C230` |
| Céu | Azul céu | `#8DB8D9` |
| Céu, horizonte | Creme horizonte | `#F3E6CF` |
| Água | Azul água | `#4A9CC2` |
| Água, espuma | Espuma | `#E8F3F7` |
| Folhagem | Verde folha | `#6E9B4A` |
| Folhagem, claro | Verde claro | `#A3C46F` |
| Madeira, escuro | Marrom escuro | `#6B3A14` |
| Pedra | Cinza pedra | `#9AA0A8` |
| Pedra, escuro | Cinza grafite | `#5B6068` |
| Fogo | Laranja fogo | `#E8832A` |
| Fogo, claro | Amarelo brasa | `#F7C948` |
| Caverna | Noite | `#2B2A33` |
| Flores | Rosa flor | `#D9708A` |
| Flores | Azul flor | `#5C7FC4` |
| Rosto | Olhos e boca | `#2A2019` |
| Bochecha | Rosa bochecha | `#E59A8A` |

Tons de pele (cinco): `#F3CBA8`, `#E2A87A`, `#C48A5A`, `#8D5A36`, `#5B3A24`.
Cabelos (cinco): preto `#2A2019`, castanho `#5A3A22`, loiro `#C79B52`, ruivo `#9A4A25`, cinza `#9AA0A8`.

### Uniforme (proposta, a confirmar contra o uniforme oficial dos Desbravadores)

O guia fixa só o lenço: **amarelo com acabamento vermelho**. O resto é proposta:

- Camisa: bege areia (`#E5DBC6`), manga curta.
- Calça ou bermuda: verde floresta (`#404F32`).
- Lenço: amarelo com borda vermelho escuro (`#77170C`).
- Mochila: marrom (`#B1611F`) com detalhes vermelho escuro e esteira (rolo de dormir) bege.
- Botas de trilha: marrom escuro, com sola bege.
- Acessórios: cantil e bússola.

### Proporções e geometria (proposta)

- Personagem com cerca de **3,3 cabeças** de altura (cabeça ligeiramente maior que o real, como pede o guia).
- Formas permitidas: caixas, prismas e pirâmides de poucos lados, **sempre com faces planas** (sombreamento facetado, sem suavização).
- Materiais **foscos**, sem textura e sem brilho. A "textura discreta" do guia fica para depois, em variação de cor por face, nunca em imagem.
- Rosto feito de caixas: olhos, sobrancelhas, bochechas e um sorriso, para ser **amigável e expressivo**.

### Orçamento de triângulos (proposta, para manter ≈ 60 FPS no celular)

| Ativo | Máximo |
|---|---:|
| Personagem completo | 2.000 |
| Árvore | 400 |
| Objeto | 300 |
| Efeito (poeira, folhas, fogo) | 600 |

### Iluminação (proposta)

Luz ambiente fria de preenchimento (sempre a mesma) e um sol suave, com sombras macias. Há **quatro situações**, todas definidas em `game/art/stage.gd`, e nenhuma prancha cria luz por conta própria:

| Situação | Uso |
|---|---|
| Estúdio | Fichas (personagens, uniforme, natureza, objetos, efeitos): sol quase frontal, sem sombra sobre o rosto |
| Manhã | Cenário da prancha 3 e HUD da prancha 7 |
| Meio-dia | Prancha 8 |
| Fim de tarde | Prancha 8: sol baixo e quente, céu alaranjado |

O material nunca muda entre situações: só a luz e a cor do céu. A luz foi calibrada medindo pixels: a areia (`#E5DBC6`) sai `#E6DFC8` e a face de cima do marrom (`#B1611F`) sai `#B86114`.

### Como a consistência é verificada

1. **Automática** (teste unitário): só cores da paleta, materiais foscos e sem textura, só formas do kit, orçamento de triângulos.
2. **Visual:** folha de contato com as oito pranchas lado a lado e conferência de cada regra da seção 9.
3. **Aprovação:** é do autor. Enquanto não houver, o status das pranchas é "aguardando aprovação".

### Status das pranchas

| # | Prancha | Arquivo | Status |
|---|---|---|---|
| 1 | Character Design | [`pranchas/01-character-design.png`](pranchas/01-character-design.png) | aguardando aprovação |
| 2 | Uniform Design | [`pranchas/02-uniform-design.png`](pranchas/02-uniform-design.png) | aguardando aprovação |
| 3 | Environment Design | [`pranchas/03-environment-design.png`](pranchas/03-environment-design.png) | aguardando aprovação |
| 4 | Nature Assets | [`pranchas/04-nature-assets.png`](pranchas/04-nature-assets.png) | aguardando aprovação |
| 5 | Props Design | [`pranchas/05-props-design.png`](pranchas/05-props-design.png) | aguardando aprovação |
| 6 | Visual Effects | [`pranchas/06-visual-effects.png`](pranchas/06-visual-effects.png) | aguardando aprovação |
| 7 | UI Design | [`pranchas/07-ui-design.png`](pranchas/07-ui-design.png) | aguardando aprovação |
| 8 | Color & Lighting | [`pranchas/08-color-and-lighting.png`](pranchas/08-color-and-lighting.png) | aguardando aprovação |

Folha de contato com as oito: [`pranchas/00-folha-de-contato.png`](pranchas/00-folha-de-contato.png).
