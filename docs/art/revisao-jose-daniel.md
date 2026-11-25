# Revisão de consistência da primeira fatia dos universos de José e Daniel

**Data:** 2026-11-25 · **Issue:** #11 · **Status:** feita antes de pedir aprovação; **a aprovação é do autor do projeto e ainda não existe**

Quem revisou foi quem produziu as pranchas, o que é um viés. Por isso há duas camadas: verificações **automáticas**, que não dependem de opinião, e uma revisão **visual** contra os sete critérios da seção 9 do documento do autor ([guia-jose-daniel.md](guia-jose-daniel.md)). A pessoa que decide é o autor.

Imagens: [`jose-daniel/`](jose-daniel/). Cinco pranchas: personagens de José (01), cidade do Egito (03), personagens de Daniel (06), cidade da Babilônia (08) e a verificação de consistência (16). Os outros 11 pacotes **não foram iniciados**, de propósito: só depois da aprovação desta fatia.

## 1. Verificação automática

`game/tests/unit/test_art_kit.gd`, agora com 8 testes (eram 5), executados no CI. Todos os modelos novos (18 personagens históricos, 12 construções, 7 objetos) entram nas verificações que já existiam (paleta, material fosco sem textura, geometria do kit, orçamento de triângulos) e há três regras novas:

| Regra nova | O que o teste confere |
|---|---|
| Não é cubo | Nos personagens históricos, no máximo 25% das peças com mais de 12 cm são caixas puras |
| Sem mistura histórica | Nenhum nó das cenas históricas (modelos novos e as pranchas 01, 03, 06 e 08) tem nome de item moderno do kit dos Desbravadores (mochila, cantil, bota, lenço, bússola, lanterna, barraca, placa) nem é o Desbravador |
| As cinco pranchas seguem o padrão | Cabeçalho do kit, sol idêntico a uma das situações do `Stage`, só material da paleta e só geometria do `LowPoly` |

**Os testes conseguem falhar.** Três mutações, depois revertidas: limite de caixas em 5% (derrubou "José jovem", que tem 7%), "Pote" na lista de proibidos (derrubou a barraca de feira) e orçamento de construção em 1.000 (derrubou o palácio, que tem 1.048). Suíte completa: **30 passaram, 0 falharam**.

Medido (`LowPoly.triangles` e contagem de peças):

| Modelo | Valor |
|---|---|
| Personagens históricos | 576 a 1.212 triângulos (limite 2.000) |
| Caixas grandes nos personagens históricos | 0% a 11% das peças (limite 25%) |
| **Desbravador, para comparação** | **62%** das peças são caixas grandes e 624 triângulos |
| Construções | 128 (casa do Egito) a 1.048 (palácio do Egito); limite 1.500 |

O 62% do Desbravador é o número que mostra o conflito entre os dois guias, não um defeito do teste: ele é de propósito excluído da regra.

## 2. Revisão visual: critérios da seção 9 do documento

| Critério | Resultado | Observação |
|---|---|---|
| É possível distinguir o Egito de José da Babilônia de Daniel? | **Atende** | Paleta (ocre, linho, azul do Nilo e terracota contra azul lápis, tijolo, petróleo e dourado envelhecido) e arquitetura (adobe inclinado, colunas de papiro e celeiros contra muralha com ameias, portão azul e zigurate) separam os dois à primeira vista |
| Personagens, objetos e cenários parecem do mesmo jogo? | **Atende, com ressalva importante** | José, Daniel, arquitetura e objetos compartilham kit, luz, paleta e cabeçalho. O **Desbravador não**: na prancha 16 ele é visivelmente mais "caixa" que os históricos |
| Low-poly consistente, sem parecer voxel nem infantil? | **Atende em parte** | Corpos, vestes e prédios são afunilados e facetados. Mas, de frente, a cabeça ainda lê como um retângulo, e os rostos são pequenos e simples. Proporção de cerca de 3,7 cabeças (calculada do modelo, não medida na imagem) |
| Comunica planejamento, sabedoria, integridade ou cooperação? | **Atende em parte** | Celeiros, cestos de grão, rolos, tabuletas, escriba e oficial comunicam administração e sabedoria. **Cooperação e integridade não aparecem**: não há cena de gente trabalhando junta |
| Evita misturas históricas evidentes? | **Atende no que o teste vê** | Nenhum item moderno, nenhuma arquitetura de outra época. **Não verificado por quem conheça o período**: o desenho é simplificação inspirada, não pesquisa histórica |
| Composição clara o suficiente para orientar a modelagem 3D? | **Atende para personagens, não para prédios** | Personagens têm frente, lado e costas. Prédios só têm vista em perspectiva, sem vista ortogonal nem medidas |
| Evita armas, combate e fantasia? | **Atende, por olhar** | Sem armas. Guardas cerimoniais levam cajado com ponteira azul. **Nenhum teste automático confere isso** |

## 3. Defeitos que eu vi e não corrigi

- Cabeça de frente ainda parece caixa. Resolver bem pede forma de cabeça mais redonda, e isso é custo de modelagem, não de ajuste.
- Os quatro estudos de expressão diferem pouco entre si (sobrancelha e boca).
- A barba "cacheada" da Babilônia parece uma treliça de losangos presa ao queixo.
- Os celeiros de cúpula em degraus parecem barracas de acampamento.
- Na cidade do Egito, a praça é de creme e lê quase branca, e o Nilo aparece só como uma faixa no fundo.
- Na cidade da Babilônia, o zigurate e o jardim em terraços ficam quase escondidos atrás da muralha.
- Na prancha 16, a vinheta da Babilônia sai maior que a do Egito (as construções são maiores, não é escala errada).
- Só existe iluminação de dia. Noite e interior não foram feitos.

## 4. O que não foi verificado

- **Precisão histórica**, por um especialista (vestuário, arquitetura, objetos).
- Se as cinco pranchas, vistas em conjunto por quem **não** as produziu, parecem de um mesmo jogo. Só o autor pode dizer.
- As pranchas dos Desbravadores não foram re-renderizadas no conjunto. Comparação byte a byte de duas delas com as imagens versionadas: prancha 01 **idêntica**; prancha 03 **diferente**. Para saber se a causa era a mudança no kit, renderizei a prancha 03 também a partir do commit anterior, sem nenhuma alteração desta etapa: o resultado é igual ao da árvore atual e igual entre execuções. Logo **a mudança no kit não altera a prancha 03**; a diferença para a imagem versionada já existia (a causa não foi apurada, provavelmente o momento em que a imagem foi gerada). Não regenerei as imagens do PR #10.

## 5. Decisões que dependem do autor

1. **Aprovar, ou pedir ajuste, desta fatia** (as cinco pranchas).
2. **O jogador é Desbravador ou personagem histórico?** Muda o que fazer com os ativos dos Desbravadores: mantê-los num conjunto à parte, ou refazê-los com `Figures` para ficarem no mesmo estilo.
3. **Quem revisa a história** (vestuário e arquitetura).
4. **Seguir com os 11 pacotes restantes**, depois de 1.
