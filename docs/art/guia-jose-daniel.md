# Além da Jornada: bíblia visual dos universos de José e Daniel

**Status:** versionado a partir do `.docx` do autor ("Bíblia visual e pacote de prompts para imagens"). Primeira fatia (pacotes 01, 03, 06, 08 e 16) produzida e revisada, **aguardando aprovação do autor** · **Issue:** #11 · Revisão: [revisao-jose-daniel.md](revisao-jose-daniel.md)

Este arquivo tem três partes:

1. **Relação com o guia dos Desbravadores** e as decisões desta etapa (abaixo), que são **propostas** e aguardam aprovação do autor.
2. **Texto do autor**, mantido como foi enviado (seções 1 a 9 do documento).
3. **Status dos 16 pacotes.**

## Relação com o guia dos Desbravadores (proposta)

O [guia dos Desbravadores](direcao-de-arte.md) e este tratam de coisas diferentes e se encontram num kit só (`game/art/`):

- **Este guia** é a especificação de **conteúdo** dos universos históricos: quem aparece, o que vestem, que arquitetura e que objetos existem em cada época.
- **O guia dos Desbravadores** segue valendo para as **regras de estilo e de consistência**: materiais foscos, sombras legíveis, luz definida em um só lugar, interface em forma de diário de expedição, cabeçalho e verificação automática.
- **Conflitos e como esta etapa os resolve:**

| Conflito | Resolução proposta |
|---|---|
| Universo moderno de acampamento x universos históricos | Os ativos dos Desbravadores **não são descartados** (o documento pede aprovação antes de descartar). Ficam num conjunto próprio. Nenhum objeto moderno entra nas cenas históricas, e um teste confere |
| "Low-poly bloqueado" x "não usar voxel cúbico puro" | Faces sempre planas, mas **formas afuniladas e chanfradas** (troncos retangulares, prismas, pirâmides). Caixas ficam para detalhes pequenos. Um teste limita as caixas grandes nos personagens históricos |
| Paleta dos Desbravadores x paletas do Egito e da Babilônia | A paleta-base continua. Cada universo ganha uma **extensão** com as cores que o documento cita |
| O jogador: Desbravador ou personagem histórico | **Decisão aberta do autor.** Não é tratada aqui |

---
Documento de produção para gerar referências visuais consistentes e entregá-las ao Claude como guia de arte para o projeto. As imagens são concept art e referências de modelagem; não devem ser tratadas como modelos 3D prontos.

## 1. Intenção do projeto

Além da Jornada é uma aventura 3D cooperativa inspirada nas vidas de José e Daniel. O jogador aprende por meio de exploração, escolhas, planejamento, conhecimento, serviço, resolução de problemas e cooperação. Não é um jogo de combate.

José: responsabilidade, administração, planejamento, interpretação de situações, organização de recursos, perseverança e serviço durante tempos de abundância e escassez.

Daniel: fidelidade aos princípios, sabedoria, coragem, domínio próprio, respeito, oração, integridade e confiança em Deus.

As narrativas bíblicas são inspiração para ambientes, personagens e desafios. Não transformar cenas sagradas em caricaturas nem reduzir a experiência a uma sequência de ilustrações literais.

A direção visual deve ser histórica e bíblica, mas estilizada, acolhedora e adequada a um jogo de aventura para diferentes idades.

## 2. Regras fixas da direção de arte

Estilo: Low-poly 3D estilizado, com volumes geométricos claros, silhuetas reconhecíveis, superfícies limpas e detalhes seletivos. Não usar voxel cúbico puro, pixel art, realismo fotográfico ou estética de brinquedo plástico.

Acabamento: Materiais predominantemente foscos, texturas discretas, iluminação global suave, sombras legíveis e profundidade atmosférica moderada. Geometria econômica, mas com composição rica.

Personagens: Proporções estilizadas e consistentes, expressões legíveis e anatomia respeitosa. Personagens históricos devem parecer habitantes do antigo Oriente Próximo e do Egito antigo, sem estereótipos modernos.

Cenários: Arquitetura, roupas, objetos e paisagens devem comunicar o período e a região. Diferenciar claramente o Egito associado à história de José da Babilônia associada à história de Daniel.

Tom: Aventura, descoberta, esperança, responsabilidade, sabedoria e fé. Evitar terror, violência gráfica, armas em destaque e fantasia medieval.

Composição: Imagens de referência limpas, com assunto principal evidente, fundo controlado e escala compreensível. Para folhas de assets, apresentar objetos separados e sem sobreposição.

## 3. Paletas e identidade dos dois universos

### Universo de José — Egito

Paleta: areia clara, ocre, dourado de trigo, terracota, marrom de madeira, azul profundo de rio e verde discreto de áreas irrigadas. A sensação é de calor, abundância, organização, escala monumental e contraste entre o vale fértil do Nilo e as áreas áridas.

### Universo de Daniel — Babilônia

Paleta: azul profundo, azul-petróleo, dourado envelhecido, tijolo queimado, areia, creme e verde de jardins irrigados. A sensação é de uma capital imperial monumental, organizada, sofisticada e culturalmente diversa, com jardins, muralhas, portões, pátios e salões.

As paletas são orientações, não filtros rígidos. Manter variações naturais e legibilidade. Não aplicar símbolos, padrões ou arquitetura de épocas muito posteriores.

## 4. Prompt mestre — usar antes de cada geração

Crie uma imagem de referência para o jogo 3D cooperativo Além da Jornada. A direção artística obrigatória é low-poly 3D estilizado, com geometria simplificada e elegante, volumes bem definidos, silhuetas fáceis de ler, materiais foscos, texturas discretas, iluminação cinematográfica suave e acabamento de jogo independente de alta qualidade. A imagem deve parecer parte de um mesmo universo visual, com proporções, densidade de polígonos, materiais, escala e iluminação coerentes.

O universo narrativo é inspirado nas vidas bíblicas de José, no Egito antigo, e Daniel, na Babilônia antiga. Respeite a ambientação histórica geral do antigo Oriente Próximo e do Egito antigo; evite misturar períodos, culturas ou arquiteturas. O tom é de aventura, exploração, cooperação, sabedoria, planejamento, serviço, fidelidade e esperança.

Não incluir combate, armas como foco, monstros, chefes, armaduras medievais, magia de fantasia, estética militar moderna, tecnologia contemporânea, elementos futuristas, texto aleatório, logotipos, marcas registradas, interface não solicitada, marca d'água ou aparência fotográfica. Não copiar personagens ou cenários de jogos, filmes ou franquias existentes.

Produza uma referência visual clara, consistente e utilizável por uma equipe de arte 3D. Priorize leitura de formas, materiais, cores e escala. Não afirmar que a imagem é um modelo 3D ou asset pronto para engine.

## 5. Pacotes de imagens e prompts específicos

### PACOTE 01 — PERSONAGENS DO UNIVERSO DE JOSÉ

**Prompt para geração:**

Prancha de design de personagens para o universo de José no Egito antigo. Mostrar um conjunto coerente de personagens: José em duas fases distintas (jovem hebreu e administrador no Egito), trabalhadores agrícolas, responsáveis pelos celeiros, comerciantes, viajantes e habitantes da cidade. Não representar todos como cópias; variar idade adulta, compleição, tons de pele, cabelos, barbas e vestimentas de forma natural e respeitosa.

José deve ser reconhecível como protagonista, com expressão inteligente, serena e determinada. Na fase jovem, roupa simples de tecido; na fase de administrador, vestimenta mais refinada, porém funcional e historicamente inspirada. Evitar coroas fantasiosas ou aparência de faraó. Mostrar corpo inteiro, vistas frontal, lateral e traseira para o protagonista, além de pequenos estudos de expressões e detalhes de roupa. Fundo neutro claro, iluminação uniforme, escala consistente, sem texto.

### PACOTE 02 — VESTUÁRIO E ACESSÓRIOS DO EGITO

**Prompt para geração:**

Prancha de vestuário e acessórios do Egito antigo, no contexto visual da história de José. Apresentar túnicas de linho, mantos, faixas, sandálias, tecidos de trabalho, vestimentas de administradores, cestos, bolsas, recipientes, ferramentas simples e acessórios de transporte de documentos ou registros. Mostrar materiais e camadas de tecido de maneira legível e estilizada. Diferenciar roupa cotidiana, roupa de trabalho e roupa administrativa sem transformar os personagens em caricaturas. Organizar cada peça isoladamente em uma folha de catálogo, com vistas úteis e fundo neutro. Não incluir roupas medievais, romanas tardias ou fantasias.

### PACOTE 03 — CIDADE, PALÁCIO E ARQUITETURA DO EGITO

**Prompt para geração:**

Concept art de um ambiente urbano do Egito antigo para Além da Jornada, inspirado no contexto da história de José. Mostrar uma cidade organizada com construções de adobe e pedra, pátios, colunas e estruturas monumentais de inspiração egípcia, áreas administrativas e caminhos de circulação. A composição deve incluir um palácio administrativo ao fundo, casas e oficinas em primeiro plano e uma praça ampla. Usar areia, ocre, terracota, dourado suave e detalhes em azul. Arquitetura estilizada low-poly, escala monumental sem exagero fantástico. Mostrar a cena em perspectiva isométrica ou câmera elevada de jogo, com áreas navegáveis e leitura clara dos espaços. Não criar pirâmides como elemento obrigatório ou cenário de fantasia.

### PACOTE 04 — AGRICULTURA, NILO, COLHEITA E ARMAZENAMENTO

**Prompt para geração:**

Prancha de ambiente e assets da agricultura no Egito antigo, baseada no período de José. Mostrar o vale fértil próximo ao Nilo, campos de trigo maduros, trabalhadores colhendo, cestos, feixes de trigo, ferramentas agrícolas simples, canais de irrigação, barcos de carga pequenos e áreas de secagem. Incluir celeiros e armazéns de grande capacidade, com entradas, compartimentos e pilhas organizadas de sacos e grãos. A imagem deve comunicar planejamento, gestão de recursos e preparação para períodos de escassez. Criar leitura visual clara de abundância e armazenamento, sem mostrar fome extrema ou sofrimento gráfico. Low-poly 3D, luz quente de manhã ou fim de tarde.

### PACOTE 05 — OBJETOS E PROPS DO UNIVERSO DE JOSÉ

**Prompt para geração:**

Folha de assets low-poly 3D isolados para o universo de José: cestos de colheita, feixes de trigo, sacos de grãos, jarros, ânforas, caixas de madeira, balanças antigas, pesos, ferramentas agrícolas, pás, foices simples, cordas, carroça, rodas, prateleiras, tábuas de registro e recipientes de armazenamento. Cada objeto deve ter volume e silhueta claros, materiais distintos (madeira, barro, pedra, tecido, metal envelhecido e palha) e escala coerente. Organizar em grade, sem sobreposição, fundo neutro, iluminação uniforme. Não incluir armas, itens mágicos ou objetos modernos.

### PACOTE 06 — PERSONAGENS DO UNIVERSO DE DANIEL

**Prompt para geração:**

Prancha de design de personagens para a Babilônia antiga no período de Daniel. Mostrar Daniel em diferentes fases da vida adulta, com expressão serena, inteligente, firme e respeitosa; três companheiros com aparências distintas; oficiais da corte; escribas; sábios; guardas cerimoniais sem armamento em destaque; servidores e habitantes da cidade. Vestimentas inspiradas no antigo Oriente Próximo, com túnicas, mantos, faixas, tecidos ornamentados de forma contida e sandálias. Diferenciar grupos por cortes, tecidos e detalhes sem estereótipos. Daniel deve parecer um jovem hebreu vivendo em contexto babilônico, não um guerreiro ou mago. Para Daniel, incluir vistas frontal, lateral e traseira e estudos de expressões. Fundo neutro e consistência de proporções.

### PACOTE 07 — VESTUÁRIO, OBJETOS E SÍMBOLOS COTIDIANOS DA BABILÔNIA

**Prompt para geração:**

Prancha de vestuário e objetos cotidianos da Babilônia antiga no contexto de Daniel. Mostrar túnicas, mantos, faixas, sandálias, bolsas, tabuletas de escrita, estiletes, rolos ou documentos, recipientes, lamparinas, bancos, mesas, tecidos e elementos de estudo. Incluir roupas de Daniel e de seus companheiros que comuniquem dignidade, simplicidade e identidade própria, sem inventar uniformes modernos. Os símbolos devem ser historicamente inspirados e discretos. Apresentar cada objeto separado, com materiais legíveis e fundo neutro. Não incluir grimórios, varinhas, runas de fantasia ou equipamentos medievais.

### PACOTE 08 — BABILÔNIA: CIDADE, PORTÕES, JARDINS E PALÁCIO

**Prompt para geração:**

Concept art de uma grande cidade inspirada na Babilônia antiga, para o universo de Daniel. Mostrar muralhas monumentais de tijolos, portões cerimoniais com decoração geométrica e relevos estilizados, ruas organizadas, pátios, palácio, jardins irrigados, canais e vegetação. Usar azul profundo, azul-petróleo, dourado envelhecido, tijolo queimado, areia e verde. A cidade deve parecer rica, monumental e habitada, mas não uma cidade de fantasia. Criar uma vista ampla de jogo em perspectiva elevada, com caminhos legíveis, pontos de interesse e diferentes níveis de profundidade. Evitar misturar arquitetura grega, romana medieval ou islâmica posterior.

### PACOTE 09 — SALÕES, PÁTIO DE ESTUDO E AMBIENTES DE DANIEL

**Prompt para geração:**

Conjunto de concept arts de ambientes internos e externos relacionados à história de Daniel: salão administrativo, pátio de estudo, espaço de escrita, aposentos simples, jardim interno, área de reunião e espaço reservado para oração. A atmosfera deve ser respeitosa e contemplativa. Usar arquitetura de tijolos, pedra, madeira e tecidos, com luz natural entrando por aberturas. Para o espaço de oração, transmitir recolhimento e serenidade sem teatralizar ou transformar a fé em efeito mágico. Criar imagens separadas por ambiente, com câmera e escala consistentes. Não mostrar violência ou encenação sensacionalista.

### PACOTE 10 — DESAFIOS VISUAIS INSPIRADOS EM JOSÉ

**Prompt para geração:**

Prancha de cenas de desafios cooperativos inspirados na vida de José, sem combate. Mostrar jogadores organizando a colheita, calculando e distribuindo estoques, transportando sacos, planejando a ocupação de um celeiro, reparando canais de irrigação, classificando recursos e preparando uma comunidade para tempos difíceis. Cada cena deve comunicar visualmente um problema e a cooperação necessária para resolvê-lo. Os desafios devem parecer atividades jogáveis e compreensíveis, não cenas de batalha. Incluir elementos visuais que indiquem planejamento, sequência, contagem, organização e trabalho em equipe. Estilo low-poly 3D, composição de jogo.

### PACOTE 11 — DESAFIOS VISUAIS INSPIRADOS EM DANIEL

**Prompt para geração:**

Prancha de cenas de desafios cooperativos inspirados na vida de Daniel, sem combate. Mostrar situações de estudo e interpretação de informações, tomada de decisões diante de pressão social, organização de tarefas, resolução de enigmas, demonstração de sabedoria, trabalho em equipe e fidelidade a princípios. Representar desafios de conhecimento, observação, memória, lógica, diálogo respeitoso e autocontrole. Não transformar Daniel em guerreiro, mago ou personagem de ação. Não mostrar violência gráfica. A atmosfera deve comunicar coragem tranquila, sabedoria e integridade. Criar cenas visualmente jogáveis em low-poly 3D.

### PACOTE 12 — NATUREZA, ANIMAIS E VIDA COTIDIANA

**Prompt para geração:**

Folha de assets de natureza e vida cotidiana compatíveis com os dois universos históricos: palmeiras, árvores de regiões áridas, plantas irrigadas, arbustos, gramíneas, campos de trigo, flores discretas, aves, peixes, animais de carga e animais domésticos adequados às regiões. Diferenciar vegetação do vale do Nilo e vegetação de jardins e áreas irrigadas da Mesopotâmia. Animais estilizados, amigáveis e proporcionais, sem aparência infantil exagerada. Organizar modelos em grupos separados, com fundo neutro, iluminação uniforme e escala relativa.

### PACOTE 13 — ITENS DE DESCOBERTA E COLECIONÁVEIS

**Prompt para geração:**

Prancha de itens colecionáveis e objetos narrativos para Além da Jornada: registros de estoque, tabuletas, mapas antigos, selos, pequenas peças artesanais, recipientes especiais, documentos, amostras de grãos, ferramentas raras e objetos que revelem pistas sobre uma missão. Os itens devem parecer artefatos históricos plausíveis e funcionais, não tesouros mágicos. Criar níveis visuais de raridade apenas por acabamento, ornamentação e estado de conservação, sem exagero de brilho ou efeitos mágicos. Cada item separado, fundo neutro e silhueta bem definida.

### PACOTE 14 — INTERFACE E IDENTIDADE GRÁFICA

**Prompt para geração:**

Direção visual de interface para Além da Jornada, inspirada em diários de expedição, registros históricos, mapas, tabuletas e documentos antigos, mas com legibilidade moderna. Criar estudos para menu principal, seleção de capítulo (José e Daniel), mapa, objetivos, inventário, registro de descobertas, progresso da equipe, diálogos e notificações. Usar molduras discretas, ícones low-poly, texturas muito sutis de papel, pedra ou tecido e tipografia legível. A interface deve ser acolhedora, organizada e contemporânea na usabilidade, sem parecer um pergaminho medieval genérico. Não inserir textos longos ou letras aleatórias; usar espaços reservados quando a geração de texto não for confiável.

### PACOTE 15 — ILUMINAÇÃO, CÉU, MATERIAIS E ATMOSFERA

**Prompt para geração:**

Prancha de estudos de iluminação e materiais para os dois universos. Para José: sol quente, luz dourada, poeira sutil, reflexos suaves na água do Nilo, sombra de estruturas de adobe e atmosfera de campos férteis. Para Daniel: luz de fim de tarde sobre tijolos, interiores com luz natural suave, jardins irrigados, céu azul profundo e iluminação serena em ambientes de estudo. Mostrar amostras de materiais: adobe, pedra, madeira, barro, linho, palha, água e metal envelhecido. Não usar efeitos mágicos, partículas exageradas ou aparência de fantasia épica.

### PACOTE 16 — PRANCHA DE CONSISTÊNCIA DO UNIVERSO

**Prompt para geração:**

Criar uma prancha de direção de arte que reúna, lado a lado, um personagem, um objeto, um trecho de arquitetura e um pequeno cenário do universo de José e do universo de Daniel. Demonstrar que ambos pertencem ao mesmo jogo e compartilham a mesma linguagem low-poly 3D, proporções, densidade de detalhes, materiais e qualidade de iluminação, mas têm identidades culturais e paletas distintas. Incluir estudos de escala relativa entre personagem, porta, mesa, cesto e construção. Composição limpa de art bible, sem texto extenso, sem elementos de outros períodos históricos.

## 6. Prompt negativo / elementos a evitar

Usar como complemento quando a ferramenta aceitar prompt negativo: photorealistic, voxel Minecraft style, pixel art, medieval fantasy, European castles, knights, swords, guns, combat, monsters, boss fight, magic spells, glowing runes, futuristic technology, modern clothing, modern buildings, Roman armor, Greek temples as dominant architecture, medieval parchment UI, plastic toy look, excessive polygons, overly detailed noisy textures, inconsistent character proportions, random text, watermark, logo, copyrighted character, copied game style.

## 7. Como gerar cada prancha

Gerar uma categoria por vez. Não pedir que a ferramenta produza os 16 pacotes em uma única imagem.

Para personagens, solicitar uma prancha por personagem ou por grupo pequeno. Para folhas de objetos, limitar a quantidade para manter cada asset legível.

Para cenários, gerar primeiro uma vista geral e depois imagens separadas de pontos de interesse e ângulos adicionais.

Manter a mesma referência visual aprovada como guia em todas as gerações seguintes, quando a ferramenta permitir usar imagens de referência.

Não confiar em texto gerado dentro das imagens. Nomes, rótulos e diagramas técnicos devem ser adicionados posteriormente em ferramenta de edição.

Revisar fidelidade histórica geral e consistência artística antes de aprovar cada prancha.

Salvar os arquivos com nomes claros: AJ_JOSE_01_CHARACTERS_01.png, AJ_JOSE_02_EGYPT_CITY_01.png, AJ_DANIEL_01_CHARACTERS_01.png e assim por diante.

## 8. Instrução para o Claude

Use este documento como especificação exclusiva da direção de arte e dos materiais de referência visual de Além da Jornada. Não altere o conceito do jogo. Não introduza combate. Não substitua a inspiração bíblica de José e Daniel por um universo genérico de exploração. Primeiro analise as imagens de referência existentes no projeto, se houver. Depois organize as imagens recebidas por pacote, identifique inconsistências e proponha ajustes visuais. Não descarte assets existentes sem aprovação. Trate as imagens como referências conceituais para produção de modelos 3D, não como modelos finais.

## 9. Critérios de aprovação visual

É imediatamente possível distinguir o Egito do universo de José da Babilônia do universo de Daniel?

Personagens, objetos e cenários parecem pertencer ao mesmo jogo?

O low-poly está consistente sem parecer voxel ou excessivamente infantil?

A imagem comunica o tema de planejamento, sabedoria, integridade ou cooperação?

A arquitetura, roupas e objetos evitam misturas históricas evidentes?

A composição é clara o suficiente para orientar modelagem 3D?

A imagem evita armas, combate e elementos de fantasia que não pertencem ao projeto?

---

## Decisões desta etapa (propostas, aguardam aprovação)

### Estilo e geometria

- Faces **planas**, sem suavização. Formas: tronco retangular afunilado (`frustum`), prismas e pirâmides de poucos lados; caixas só em detalhes (olhos, fivelas, tijolos pequenos).
- **Não voxel cúbico puro:** nos personagens históricos, no máximo **25%** das peças com mais de 12 cm podem ser caixas puras. Medido por teste.
- Proporção dos adultos históricos: cerca de **3,6 cabeças** de altura (um pouco mais adulta que a dos Desbravadores), com variação de altura e compleição.
- Rosto simples e amigável: olhos, sobrancelhas e um sorriso discreto. Barba por traço, sem exagero.
- Materiais foscos e **sem textura** por enquanto. As "texturas discretas" do documento ficam para quando houver modelos finais.

### Paletas (propostas)

Todas se somam à paleta-base (marrom, vermelho escuro, verde-floresta, bege areia, cinza claro e as complementares).

**Egito (José):** areia clara (o bege da base), ocre `#C98B2B`, dourado de trigo `#D9A93A`, terracota `#C0602F`, adobe `#C9A37A`, linho `#EFE6D2`, azul do Nilo `#1F4E79` e o verde-folha da base para as áreas irrigadas.

**Babilônia (Daniel):** azul lápis `#1B3F7A`, azul-petróleo `#1F5F6B`, dourado envelhecido `#B8923A`, tijolo queimado `#8E3F2A`, o bege e o creme da base e verde de jardim `#3F7F52`.

### Elenco e vestuário (simplificações inspiradas, a revisar)

Não sou historiador: o desenho é uma **simplificação inspirada** no antigo Oriente Próximo e no Egito, a ser revisada por quem conheça o período.

- **José jovem:** túnica de tecido simples, faixa na cintura, sandálias. **José administrador:** túnica longa de linho com faixa e acabamento dourado, medalhão no peito, bolsa de registros. Sem coroa e sem aparência de faraó.
- **Egito:** trabalhadores com saiote de linho e pano na cabeça; responsáveis pelos celeiros com saiote longo e faixa; comerciantes com túnica e cestos; viajantes com manto e cajado.
- **Daniel e companheiros:** túnicas longas e mantos em azul-petróleo, creme e tijolo, com bordas discretas. Oficiais da corte com túnica franjada e acabamento dourado antigo; escribas com tabuleta de argila; sábios com manto longo; **guardas cerimoniais com cajado, nunca arma em destaque**.
- Tons de pele, idades e compleições variados, sem estereótipo.

### Arquitetura (simplificada)

- **Egito:** casas de adobe de paredes levemente inclinadas, colunas de papiro com faixas azuis e douradas, celeiros em cúpulas e armazéns, palácio com colunata. Sem pirâmide obrigatória.
- **Babilônia:** muralha de tijolo com torres e ameias, portão monumental de tijolo esmaltado azul com faixas de relevo geométrico, zigurate em degraus, pátios e jardins em terraços com canais.
- Nada de arquitetura grega, romana, medieval ou islâmica posterior.

### Nomes de arquivo (seção 7 do documento)

`AJ_JOSE_01_CHARACTERS_01.png`, `AJ_JOSE_02_EGYPT_CITY_01.png`, `AJ_DANIEL_01_CHARACTERS_01.png`, `AJ_DANIEL_02_BABYLON_CITY_01.png` e `AJ_CONSISTENCIA_01.png`, em `docs/art/jose-daniel/`.

### Limite honesto

As imagens são **renders do Godot** de modelos montados por código, com acabamento mais simples que o das imagens que os prompts do documento pedem a um gerador. Elas não substituem a arte de um artista 3D; servem de referência consistente, e o kit é o padrão que ele seguiria.

## Status dos 16 pacotes

| Pacote | Tema | Status |
|---|---|---|
| 01 | Personagens de José | aguardando aprovação (`AJ_JOSE_01_CHARACTERS_01.png`) |
| 02 | Vestuário e acessórios do Egito | não iniciado |
| 03 | Cidade, palácio e arquitetura do Egito | aguardando aprovação (`AJ_JOSE_02_EGYPT_CITY_01.png`) |
| 04 | Agricultura, Nilo, colheita e armazenamento | não iniciado |
| 05 | Objetos e props de José | não iniciado |
| 06 | Personagens de Daniel | aguardando aprovação (`AJ_DANIEL_01_CHARACTERS_01.png`) |
| 07 | Vestuário e objetos da Babilônia | não iniciado |
| 08 | Babilônia: cidade, portões, jardins e palácio | aguardando aprovação (`AJ_DANIEL_02_BABYLON_CITY_01.png`) |
| 09 | Salões, pátio de estudo e ambientes de Daniel | não iniciado |
| 10 | Desafios inspirados em José | não iniciado |
| 11 | Desafios inspirados em Daniel | não iniciado |
| 12 | Natureza, animais e vida cotidiana | não iniciado |
| 13 | Itens de descoberta e colecionáveis | não iniciado |
| 14 | Interface e identidade gráfica | não iniciado (a interface dos Desbravadores é ponto de partida) |
| 15 | Iluminação, céu, materiais e atmosfera | não iniciado |
| 16 | Consistência do universo | aguardando aprovação (`AJ_CONSISTENCIA_01.png`) |

Os pacotes não iniciados só começam **depois da aprovação da primeira fatia**.
