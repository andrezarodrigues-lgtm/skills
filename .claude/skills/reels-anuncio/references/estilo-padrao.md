# Estilo padrão

Ponto de partida quando o usuário não mandou referência. Assim que chegar referência,
medir nela e gravar `<pasta_dos_videos>/edit/estilo.md`, que substitui este arquivo.

As medidas de layout abaixo vêm de Reels publicados e funcionam bem em 1080×1920.

**Paleta neutra**

| papel | hex |
|---|---|
| escuro (fundo de chips) | `#141414` |
| cor herói | `#FFD400` |
| acento | `#FF4D4D` |
| claro | `#F6F6F6` |

Regra: **no máximo um elemento na cor herói por quadro.**

**Tipografia.** Poppins (Google Fonts, OFL, fonts.google.com/specimen/Poppins). Bold
(legenda), ExtraBold (inserts), Light Italic (inserts mais elegantes), Medium (chips).

**Tom dos textos na tela.** Direto, coloquial, sem travessões.

**Especificação visual**

| elemento | especificação |
|---|---|
| legenda | Poppins Bold 60px · branco · contorno ~2px · centralizada · **centro vertical a 73,9%** da altura · largura máx. 920px · até 2 linhas |
| insert grande | Poppins ExtraBold ou Light Italic ~148px · branco · sem contorno · sombra suave (preto 20%, deslocamento 6px, blur 9) · faixa 55% a 72% · quebra em 2 linhas acima de 900px |
| chip | fundo escuro a 82% · texto claro Medium · contraste ≥ 4,5:1 medido |

**Armadilha do libass.** Se gerar legenda por `.ass` em vez do Remotion: os valores de
estilo escalam por `1920 / PlayResY`. Com `PlayResY=288` isso é 6,67×, então
`Outline=2.5` vira ~17px na tela. Para contorno real de 2px, usar `Outline=0.3`.
