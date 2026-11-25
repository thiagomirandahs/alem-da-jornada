# Primeiro teste em Android

**Data:** 2026-11-24 · **Issue:** #7 · **Godot:** 4.7.2 · **APK:** debug, 27 MB, `arm64-v8a`, Android 7.0 ou mais novo (minSdk 24), só a permissão de internet

Este relatório separa o que foi **medido** do que foi **observado** e do que **não foi testado**. Complementa o [relatório da primeira entrega](relatorio-primeira-entrega.md).

## Resumo

- O APK exporta por linha de comando, instala e abre em um aparelho real, conecta ao servidor do PC pela rede local e a interação é decidida pelo servidor.
- No aparelho, o cliente manteve **≈ 60 FPS** (o limite da tela) com p95 de tempo de quadro de até 17,3 ms.
- Foi **um aparelho, um jogador por vez, uma sessão curta**. O que isso não prova está na seção 4.
- Achado principal: ao perder o servidor, o app leva **≈ 30 s** para voltar à tela de conexão, e a cena fica congelada dizendo "Conectado".

## 1. Aparelho e ambiente

| | |
|---|---|
| Aparelho | Samsung Galaxy A25 5G (SM-A256E), Android 16 (API 36), Exynos 1280, ≈ 7,2 GiB de RAM visíveis ao sistema |
| Tela | 1080×2340, 450 dpi, 60 Hz (a tela aceita 120 Hz; o app rodou a 60) |
| Renderizador | Compatibilidade (OpenGL ES), por `rendering_method.mobile` |
| Servidor | O notebook Windows 10 do desenvolvimento, escutando **só** no IP do PC na rede local (`--bind=`), sem autenticação |
| Rede | Celular e PC no mesmo Wi-Fi. O Windows classifica essa rede como "Pública" |

## 2. Medido

Coletado pelo próprio app (build de debug, `FrameStats`, janelas de 5 s, no `logcat`) e pelo Android.

| Medida | Resultado |
|---|---|
| Início a frio (tempo até a primeira tela, `am start -W`) | 1,3 s na primeira abertura após instalar; 0,84 s na segunda |
| FPS médio por janela de 5 s | 59,7 a 59,9 (6 janelas, parado e andando) |
| Tempo de quadro, p95 | 16,67 a 17,25 ms |
| Tempo de quadro, máximo | 72 ms na primeira janela (logo após conectar); 18 a 25 ms nas outras |
| Memória do app | 246 MB (PSS), 313 MB (RSS) |
| CPU do app | 48% de um núcleo, **uma única amostra** do `top` |
| Temperatura da bateria | 38,2 °C ao fim, em uns 6 minutos de uso |
| Servidor, visto pelo celular | 60 ticks/s, 2,9 kB/s de saída e 2,0 kB/s de entrada, igual ao cliente em script da medição de carga |

**Como ler o FPS:** a tela limita a 60. Isso mostra que o app **alcança** 60, mas **não mostra a folga**: não sabemos quanto a mais ele aguentaria.

## 3. Observado

- **Funcionou no aparelho:** instalar, abrir, digitar `ip:porta`, conectar, ver a cena e o HUD, joystick, giro da câmera e botão **Interagir**. O log do servidor registrou duas recusas ("longe") e uma coleta, e o HUD do celular mostrou "Você coletou Basket".
- **Quem tocou:** o agente injetou, por `adb`, um toque no joystick, um arrasto de câmera e **um** toque no botão. O log mostra **três** pedidos de coleta. Os demais toques, inclusive o caminho até o cesto, foram feitos com o celular em uso, provavelmente à mão. Não está confirmado por quem.
- **Perda do servidor:** com o servidor encerrado, o app voltou sozinho à tela de conexão, com "O servidor desconectou" e o endereço ainda preenchido. Levou **≈ 30 s**, o tempo de desistência do ENet. Durante esse tempo a cena parece travada.
- **Visual:** as sombras têm borda serrilhada no renderizador Compatibilidade.
- **Firewall:** a conexão UDP passou, mas **não foi possível identificar qual regra do firewall permitiu**. Um `ping` do celular ao PC foi bloqueado (100% de perda), então o **tempo de ida e volta da rede não foi medido**.

## 4. Não testado

- **Outros aparelhos e versões do Android.** Só um celular, de gama média, com Android 16. O mínimo declarado é o Android 7.0, **sem teste**. A versão de 32 bits (`armeabi-v7a`) está desligada.
- **Celular e PC jogando juntos**, e vários celulares. Houve um jogador por vez.
- **Latência real, Wi-Fi ruim, dados móveis e jogar fora da rede local.**
- **Sessões longas:** consumo de bateria, aquecimento e vazamento de memória. A sessão teve cerca de 6 minutos.
- **Ciclo de vida do app:** ir para segundo plano e voltar, rotação, ligação ou notificação durante a partida.
- **Conforto dos controles:** tamanho do joystick e do botão, sensibilidade do giro e o uso com mãos de crianças. Só se checou que funcionam, não se são agradáveis.
- **Desempenho em aparelhos mais fracos**, que são o público provável.

## 5. Achados e próximos passos candidatos

Cada um pede uma issue própria se for adiante.

1. **Mostrar "sem resposta do servidor" depois de uns 3 s sem receber estado**, em vez de ficar 30 s parado.
2. **Medir a folga de desempenho:** com o limite de 60 FPS retirado ou com uma cena mais pesada.
3. **Sombras serrilhadas:** ajustar a qualidade da sombra no Compatibilidade.
4. **Identificador do pacote e ícone são provisórios** (`com.example.alemdajornada`).
5. **Repetir em aparelho mais simples** e com Android mais antigo.
