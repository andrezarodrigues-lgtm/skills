# Marca: ContrataPJ

Bloco de marca usado pela seção 2 do `SKILL.md`. Para um cliente novo, copiar este
arquivo com o nome do cliente e trocar todos os valores.

**Paleta**

| papel | hex |
|---|---|
| navy (fundo, chips) | `#1C265E` |
| índigo — **cor herói** | `#4259DF` |
| coral — acento | `#DE5968` |
| off-white | `#F6F6F6` |

Regra: **no máximo um elemento na cor herói por quadro.**

**Tipografia.** Poppins (Google Fonts, licença OFL — baixar em
fonts.google.com/specimen/Poppins). Pesos usados: Bold (legenda), ExtraBold (inserts
autorais), Light Italic (inserts no padrão publicado), Medium (rótulos e chips).

**Tom de voz.** Direto, coloquial, sem juridiquês, **sem travessões**.

**Especificação visual medida** (medida nos vídeos publicados do perfil, não estimada):

| elemento | especificação |
|---|---|
| legenda | Poppins Bold 60px · branco · contorno ~2px · centralizada · **centro vertical a 73,9%** da altura · largura máx. 920px · até 2 linhas |
| insert, padrão publicado | Poppins **Light Italic** 148px · branco · **sem** contorno · sombra suave (preto 20%, deslocamento 6px, blur 9) · centro vertical a 52,6% · quebra em 2 linhas acima de 900px de largura |
| insert, direção autoral | Poppins ExtraBold · branco · sombra suave · posicionado pela seção 6 |

> Se o briefing pedir "nenhum motion na direção do rosto", o centro de 52,6% do padrão
> publicado **não vale** — usar a faixa da seção 7 do `SKILL.md` (inserts entre 55% e 72%).

**Armadilha do libass.** Se em algum momento você gerar legenda por `.ass` em vez do
Remotion: os valores de estilo escalam por `1920 / PlayResY`. Com `PlayResY=288` isso é
6,67×, então `Outline=2.5` vira ~17px na tela. Para um contorno real de 2px, usar
`Outline=0.3`.

**Vinheta de fecho (seção 10 do SKILL.md).** Chips "Contrato", "Nota fiscal",
"Pagamento" convergem num pulso índigo, do qual nasce o ícone do logo (um elo). Fatiar o
logo em ícone / wordmark / tagline em `public/brand/`.
