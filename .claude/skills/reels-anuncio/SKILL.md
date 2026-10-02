---
name: reels-anuncio
description: Transforma vídeo bruto longo (talking head, gravação de celular ou DJI) em Reel/anúncio vertical 1080x1920 com corte dinâmico, punch-in ancorado no rosto, legenda queimada por palavra e motion graphics que significam a palavra falada. Use quando o usuário pedir para editar um vídeo, cortar um vídeo longo em anúncio, ou fazer um Reel, Short ou TikTok a partir de material gravado. O estilo visual vem das referências que o usuário mandar. Pipeline ffmpeg corta, Remotion compõe, verificação por medição.
---

# Reels / anúncios — método de produção (v2)

Este arquivo é o método. O estilo (paleta, fonte, medidas de legenda e insert, ritmo)
vem das **referências que o usuário mandar**: vídeos de anúncio que ele quer imitar.
Medir o estilo nelas (posição e corpo da legenda, contorno, sombra, cores, fonte
aproximada, cortes por segundo, tipo de insert) e registrar em
`<pasta_dos_videos>/edit/estilo.md`. Mostrar ao usuário o que foi medido antes de editar.
Sem referência, partir de `references/estilo-padrao.md`.

Skills irmãs neste repo:
- `video-use`: `helpers/transcribe.py` (ElevenLabs Scribe, palavra por palavra) e
  `helpers/timeline_view.py` (filmstrip + waveform nos pontos de corte).
- `remotion-motion-graphics`: craft de animação (molas, escalonamento, camadas). Ler
  antes de escrever código Remotion.

Saídas sempre em `<pasta_dos_videos>/edit/`, nunca dentro das pastas das skills.

---

## PEDIDO (coletar antes de cortar)

Se o usuário não respondeu algum item, perguntar numa única mensagem. Não cortar antes
de ter o pedido fechado.

- **Referências de estilo:** … (vídeos que o anúncio deve parecer)
- **Tema / roteiro:** …
- **Material bruto:** … (caminho da pasta com os vídeos)
- **Duração alvo:** … (padrão: o que a fala pedir, tipicamente 25 a 45s com a vinheta)
- **CTA falado:** … (se já está no material, indicar; se não, dizer qual usar)
- **Direção dos inserts:** ( ) autoral, livre · ( ) seguir o padrão publicado do perfil
- **Vinheta de fecho:** ( ) sim, 6s · ( ) não
- **Áudio:** ( ) só voz · ( ) voz + trilha/SFX
- **Enquadramento:** ( ) punch-in nos momentos-chave · ( ) fixo
- **Restrições extras:** ( ) nenhum motion na direção do rosto · ( ) outra: …

---

## 1. Entregável

Reel vertical **1080×1920 · 30fps · H.264 CRF 16**, corte dinâmico total, legenda
queimada, motion graphics nos pontos de ênfase. Documentar as decisões num `project.md`
na pasta de trabalho.


## 2. Estilo

O `estilo.md` do projeto (medido nas referências) ou, na falta dele,
`references/estilo-padrao.md`. Define paleta (com uma cor herói), tipografia e pesos, tom
dos textos e a especificação de legenda e insert. Toda menção a "seção 2" abaixo aponta
para esse arquivo.

## 3. Setup do zero

```bash
# ffmpeg
brew install ffmpeg                 # macOS
sudo apt install -y ffmpeg          # Debian/Ubuntu

# projeto Remotion
npm create video@latest -- --blank reel
cd reel
npm i typescript@5.6.3              # obrigatório: o bundler usa ts.sys, removido no TS 7

# medição e verificação
python3 -m pip install "opencv-python-headless==4.10.0.84" pillow numpy pypdf
```

Baixar a fonte do estilo (no exemplo abaixo, Poppins, a padrão) e colocar os `.ttf` em `public/fonts/`. Carregar por `@font-face`, nunca
por CDN — o render roda offline:

```tsx
// src/Fonts.tsx
import { staticFile } from "remotion";
export const Fonts = () => (
  <style>{`
    @font-face{font-family:PoppinsBody;  src:url(${staticFile("fonts/Poppins-Bold.ttf")})}
    @font-face{font-family:PoppinsHero;  src:url(${staticFile("fonts/Poppins-ExtraBold.ttf")})}
    @font-face{font-family:PoppinsHeroIt;src:url(${staticFile("fonts/Poppins-LightItalic.ttf")})}
    @font-face{font-family:PoppinsUI;    src:url(${staticFile("fonts/Poppins-Medium.ttf")})}
  `}</style>
);
```

## 4. Pipeline

**ffmpeg corta, Remotion compõe.**

1. **Transcrever** cada bruto com timestamps **por palavra**. Qualquer ASR serve desde
   que produza `[{t, start, end}, …]` em segundos. Duas opções:
   - ElevenLabs Scribe (API, melhor em PT-BR rápido);
   - local: `pip install faster-whisper`, modelo `large-v3`, `word_timestamps=True`.
2. **Definir os cortes.** Eliminar toda pausa, respiro, bastidor e tomada abortada.
   Quantizar cada duração em **número inteiro de quadros a 30fps** — é o que impede
   deriva acumulada.
3. **Exportar os segmentos** sem áudio, **no tamanho nativo da fonte** (ou 1,5× do
   destino, o que for menor). A resolução extra é o que permite punch-in sem perder
   pixel. Tonemap HDR→SDR só se a fonte for HDR (ver seção 9).
4. **Montar a voz** extraindo PCM **direto da fonte**, nunca dos MP4 já codificados
   (o priming do AAC introduz deriva). Concatenar e normalizar:
   `loudnorm=I=-14:TP=-1:LRA=11`. Conferir: `amostras ÷ 48000 × 30` tem que dar o total
   de quadros, exato.
5. **Gerar as legendas** (seção 8).
6. **Compor e renderizar:**
   `npx remotion render src/index.ts Reel out/reel.mp4 --codec h264 --crf 16`

**Sincronia (regra crítica).** Cada segmento entra num `<Sequence from={offset}>` no
quadro exato, e a transição acontece na **entrada** do clipe, sem consumir tempo da
linha do tempo. A voz vai numa faixa contínua separada. **Nunca usar
`TransitionSeries`**: ela encurta o vídeo a cada transição e dessincroniza a fala.

## 5. Como cortar

- Sempre em fronteira de palavra, com folga de 30 a 100ms.
- Remover também as pausas **internas** a uma fala contínua (dividir o segmento em dois
  e colar). É isso que dá o ritmo.
- Entre duas tomadas do mesmo trecho, escolher a mais limpa e registrar no `project.md`
  por que a outra foi descartada.
- Conferir o transcript contra o que foi realmente dito: o ASR erra em fala rápida.

## 6. Enquadramento: punch-in ancorado no rosto

O zoom **não** puxa o rosto para o centro do quadro. Ele é ancorado no próprio rosto,
que cresce em torno de si mesmo, continua alto e deixa a metade inferior livre.

### 6.1 Medir o rosto (nunca estimar)

Extrair 3 quadros de cada segmento (25%, 50%, 75% da duração) e detectar:

```python
import cv2
cas  = cv2.CascadeClassifier(cv2.data.haarcascades + "haarcascade_frontalface_default.xml")
alt  = cv2.CascadeClassifier(cv2.data.haarcascades + "haarcascade_frontalface_alt2.xml")
prof = cv2.CascadeClassifier(cv2.data.haarcascades + "haarcascade_profileface.xml")

g = cv2.equalizeHist(cv2.cvtColor(img, cv2.COLOR_BGR2GRAY))   # equalizar é o que faz funcionar
for c in (cas, alt, prof):
    fs = list(c.detectMultiScale(g, 1.06, 6, minSize=(120, 120)))
    if fs: break
x, y, w, h = max(fs, key=lambda r: r[2] * r[3])               # média dos 3 quadros
```

Detecção por tom de pele **não funciona** em locação com parede de madeira ou tijolo:
a caixa volta como o quadro inteiro. Haar com `equalizeHist` funciona.

Da caixa medida, em fração do quadro, com folga de 5,5% acima (cabelo) e 5,5% abaixo
(queixo):

```
ht = topo − 0,055        hb = base + 0,055
fx = centro horizontal   fy = ht + 0,35·(hb − ht)      # linha dos olhos
```

### 6.2 Os três tetos de zoom

Com a âncora em `fy`, um ponto `v` do rosto vai parar em `y(v) = fy + (v − fy)·z`. Daí:

```
base da cabeça ≤ 0,52   →   z ≤ (0,52 − fy) / (hb − fy)
topo da cabeça ≥ 0,10   →   z ≤ (fy − 0,10) / (fy − ht)
resolução da fonte      →   z ≤ largura_nativa / 1080
```

Usar o **menor dos três**, por segmento. Numa fonte de 1512px de largura o teto de
resolução já é 1,40, então 1,26 a 1,30 costuma ser o limite confortável.

### 6.3 O componente (é aqui que quebra)

```tsx
const NAT_W = 1512, NAT_H = 2688;        // tamanho nativo do segmento exportado
const FIT = 1080 / NAT_W;

const eff = z * entryScale;
// O ponto (fx, fy) do quadro fica FIXO enquanto a escala varia.
// Deduzido de x(u) = fx·1080 + (u − fx)·1080·eff, com o elemento em (0,0) e origin 0 0.
const tx = p.fx * 1080 * (1 - eff);
const ty = p.fy * 1920 * (1 - eff);

// Com âncora fora do centro a sobra lateral é ASSIMÉTRICA.
const slackX = Math.min(p.fx, 1 - p.fx) * 1080 * (eff - 1);
const slide  = !p.cut ? (i % 2 ? -1 : 1) * Math.min(42, slackX * 0.6) * (1 - t) : 0;

<div style={{
  position: "absolute", left: 0, top: 0, width: NAT_W, height: NAT_H,
  transform: `translate(${tx + slide}px, ${ty}px) scale(${FIT * eff})`,
  transformOrigin: "0 0",
}}>
  <OffthreadVideo src={staticFile(`clips/seg_${i}.mp4`)} muted
    style={{ width: NAT_W, height: NAT_H, objectFit: "cover" }} />
</div>
```

**Não** usar `transform-origin: fx% fy%` junto com o scale de ajuste: os dois se
combinam e deslocam a imagem. Num material 1512×2688 com `fy = 0,28` o erro foi de
169px para cima, expondo fundo na borda inferior.

Efeito colateral bom: sem deslocamento vertical, escalar (>1) em torno de um ponto
interno **sempre** cobre o quadro. Não há como expor fundo na vertical.

### 6.4 Ritmo (decidir por beat, não por segmento solto)

| momento | enquadramento |
|---|---|
| gancho | largo, **empurra devagar** (1,00 → 1,12), cria tensão |
| desenvolvimento | largo, para respirar |
| remate de um bloco | **corte seco em close** (1,22 a 1,26) |
| onde vai entrar insert | **largo (1,00)**, para o gráfico ter onde caber |
| antes do desfecho | volta ao largo, alívio |
| desfecho / punchline | o **mais fechado do vídeo** |
| CTA | plano médio (1,10 a 1,15) |

Transição de entrada: 8 quadros. Em corte seco, micro-punch 1,05 → 1,00 e blur 3px
limpando. Nos outros, 1,14 → 1,00, deslize alternado e blur 6px limpando.

## 7. Zona segura e a faixa dos inserts

| faixa | limite |
|---|---|
| rosto | topo ≥ 10%, base ≤ 52% |
| **inserts** | **55% a 72%** |
| legenda | centro 73,9%, base < 80% |

A legenda é suprimida enquanto há insert na tela, então as duas faixas podem encostar
sem colidir.

**Elementos radiais são a armadilha.** Um círculo centrado em 63,5% com 640px de
diâmetro sobe até 46% da altura — em cima do rosto. Qualquer pulso, onda de choque ou
halo precisa da **altura travada**: uma elipse de no máximo 300px de altura põe o topo
em 55,7%.

## 8. Motion graphics

**Princípio: o movimento significa a palavra.** Antes de animar, perguntar "o que essa
palavra faz?" e traduzir isso em movimento. Régua:

| palavra | movimento |
|---|---|
| "bagunça" | as letras se desalinham e giram |
| "vago" | o texto se dissolve (espaçamento abre, blur cresce) |
| "indefinido" | barra de progresso empaca e pulsa |
| "genérica" | cópias fantasma se acumulam atrás |
| "ninguém lê" | risco atravessa o texto |
| "em um lugar só" | chips espalhados **convergem** para uma pilha alinhada |
| "processo" | slam + onda de choque + tremor de câmera |

3 a 5 inserts num reel de 30 a 45s, distribuídos. Cada um sincronizado com a palavra
falada — pegar o quadro exato da palavra no JSON de legendas, não o do segmento.

**Legibilidade: medir, não supor.** Texto branco sobre fundo translúcido claro some em
locação clara — num corredor com janela estourada, um chip inteiro desapareceu. Fundo
**escuro e opaco**, como `rgba(28,38,94,0.82)` ou a cor escura da paleta a ~82%, resolve
em qualquer fundo: contraste medido de 7,9 a 8,8:1 (mínimo WCAG é 4,5:1).

```python
def luminancia(rgb):
    c = [v / 255 for v in rgb]
    c = [x / 12.92 if x <= 0.04045 else ((x + 0.055) / 1.055) ** 2.4 for x in c]
    return 0.2126*c[0] + 0.7152*c[1] + 0.0722*c[2]
# contraste = (maior + 0,05) / (menor + 0,05), texto contra o fundo MEDIANO
# dos pixels não-texto dentro da caixa do texto
```

**Craft obrigatório.** Nunca easing linear (curva sempre, com `extrapolateLeft` e
`extrapolateRight: "clamp"`); entrada com mola em 2-3 propriedades juntas;
escalonamento de 3 a 6 quadros por palavra; saída mais rápida que a entrada (~8 contra
~15 quadros); respiração senoidal acima de 2s em tela; um só elemento na cor herói por
quadro; `gap` em px, nunca em `em` (em resolve contra o corpo do pai, não do texto).

## 9. Legendas

Estilo e posição: seção 2. Sincronizada por palavra, com **pop de escala** na palavra
ativa (1 → 1,05) e **sem troca de cor** — a cor herói fica reservada aos inserts.

**Suprimir a legenda enquanto um insert grande estiver na tela**, com 4 quadros de
fade. Sem isso o mesmo texto aparece duas vezes no quadro.

```tsx
const captionVisibility = (abs: number, wins: {from:number; to:number}[]) => {
  const FADE = 4;
  let sup = 0;
  for (const h of wins) {
    let s = 0;
    if (abs >= h.from && abs <= h.to) s = 1;
    else if (abs > h.from - FADE && abs < h.from)
      s = interpolate(abs, [h.from - FADE, h.from], [0, 1], {extrapolateLeft:"clamp", extrapolateRight:"clamp"});
    else if (abs > h.to && abs < h.to + FADE)
      s = interpolate(abs, [h.to, h.to + FADE], [1, 0], {extrapolateLeft:"clamp", extrapolateRight:"clamp"});
    sup = Math.max(sup, s);
  }
  return 1 - sup;        // 1 = visível, 0 = suprimida
};
```

**Gotcha do gerador.** Os cortes têm folga de ~50ms, então segmentos vizinhos se
sobrepõem em tempo de fonte e a mesma palavra é reivindicada duas vezes, produzindo
legendas órfãs. Cada palavra tem que ser reivindicada por **um** segmento:

```python
claimed = set()
for si, (s0, n_frames, grupos) in enumerate(SEGS):
    s1 = s0 + n_frames / FPS
    if si + 1 < len(SEGS):
        s1 = min(s1, SEGS[si + 1][0])          # não invadir o próximo
    for k, w in enumerate(TODAS_AS_PALAVRAS):
        if k in claimed:
            continue
        if s0 <= (w["start"] + w["end"]) / 2 < s1:
            palavras_do_segmento.append(w)
            claimed.add(k)
```

Juntar também os pares que o ASR separa e que se escrevem juntos (nomes de marca,
produto, @perfil).

## 10. Vinheta de fecho (6s, opcional)

Só entra se o usuário mandar logo. Conceito: a promessa do produto virada em movimento.
Exemplo: três chips com os benefícios entram escalonados, convergem para o centro, se
fundem num pulso na cor herói, e do pulso nasce o ícone do logo. Depois a marca se monta:
ícone assenta, wordmark revelado por máscara (`clip-path: inset`) da esquerda para a
direita, tagline sobe. Fundo na cor escura da paleta com malha das cores de acento em
movimento.

Para isso, **fatiar o arquivo do logo** em ícone / wordmark / tagline e guardar as
peças em `public/brand/`. É o que permite a marca se montar em vez de só aparecer.

Cronologia em 180 quadros: chips 0–44 · convergem 44–62 · pulso 62 · ícone nasce 60–84
· ícone assenta 84–108 · wordmark 108–132 · tagline 134–150 · respiro 150–166 · saída
166–180.

## 11. Regras técnicas (as que quebram o vídeo)

1. **Rotação.** Brutos de celular vêm paisagem-codificados com tag de rotação. Ler a
   tag (`ffprobe -show_streams | grep -i rotat`) antes de decidir a orientação, senão a
   escala sai errada. Fonte DJI em retrato nativo não tem a tag.
2. **HDR→SDR.** Conferir o espaço de cor antes. Só aplicar tonemap em material
   BT.2020/HLG ou PQ:
   `zscale=t=linear:npl=100,format=gbrpf32le,zscale=p=bt709,tonemap=tonemap=hable:desat=0,zscale=t=bt709:m=bt709:r=tv,format=yuv420p`
   Aplicar em material BT.709 lava a imagem.
3. **Nitidez no punch-in.** Manter o elemento de vídeo no tamanho **nativo** e levar a
   escala ao destino. Elemento em 1080 com zoom por cima faz o Chromium ampliar um
   raster já reduzido: 1,39× menos nitidez, medido por variância do laplaciano.
4. **`transform-origin` fora do centro** somado ao scale de ajuste desloca a imagem.
   Ver 6.3.
5. **Orçamento de deslocamento.** Ver 6.3 — a sobra é assimétrica.
6. **alpha WebM.** Forçar `-c:v libvpx-vp9` na entrada, senão o decoder nativo do
   ffmpeg ignora o canal alfa e o vídeo entra preto.
7. **TypeScript 5.x.** O bundler do Remotion usa `ts.sys`, ausente no TS 7.
8. **Determinismo.** Sem `Math.random()` e sem `Date.now()` — quebram o render em
   paralelo. Para variação, indexar pelo número do elemento.

## 12. Verificação (não entregar sem isto)

**Isolar as camadas antes de medir.** Medir no vídeo composto não funciona: o detector
confunde camisa branca e brilho de parede com os gráficos, e a medição volta sem
sentido. Registrar duas composições de depuração:

```tsx
<Composition id="DbgMotion" component={/* só os Highlights sobre preto */} … />
<Composition id="DbgFace"   component={/* só o Footage                */} … />
```

Renderizar as janelas dos inserts com
`--sequence --image-format png --frames=A-B` e medir a caixa dos gráficos como
"qualquer pixel com luminância > 10".

Depois, extrair quadros em **resolução plena** nos pontos de corte, em cada insert e no
fecho, e **olhar cada um**. Filmstrip em miniatura não serve para julgar detalhe.

Fechar com uma tabela de números, não com "ficou bom":

| medida | limite |
|---|---|
| folga entre a base da cabeça e o topo do motion, por insert | > 0 |
| caixa dos inserts (vertical) | 55% – 72% |
| topo da cabeça, amostrado a cada 15 quadros no vídeo todo | > 10% |
| base da cabeça, mesma amostragem | < 55% |
| exposição de fundo: % de pixels pretos na borda, em todos os cortes | 0% |
| contraste do texto sobre o fundo real | ≥ 4,5:1 |
| nitidez no rosto (variância do laplaciano) por nível de zoom | comparar entre zooms |
| legenda: centro, base e espessura do contorno | 73,9% · < 80% · ~2px |
| áudio da fala (`volumedetect`) | média ~ −16 dB, pico ≤ −1 dB |
| fecho | silêncio |
| sincronia: amostras ÷ 48000 × 30 | = total de quadros, exato |

Corrigir, re-renderizar, re-inspecionar. Entregar só depois de uma passagem limpa.

## 13. Como reportar

No fim, dizer: o que foi cortado e por quê; quais inserts e o raciocínio de cada
movimento; o ritmo de enquadramento; **os números da verificação**; e o que ficou fora
de propósito (ex.: sem trilha) com o motivo. Se apareceu bug no caminho, explicar a
causa raiz, não só que foi corrigido.

---

## Princípio que atravessa tudo

**Medir, não estimar.** Toda vez que este processo falhou, a causa foi a mesma: uma
decisão visual tomada no olho, em miniatura, em vez de medida em resolução plena. A
posição da legenda, a espessura do contorno, o alcance do rosto no zoom, o contraste do
chip, a nitidez do punch-in — tudo isso é número, e número se confere.
