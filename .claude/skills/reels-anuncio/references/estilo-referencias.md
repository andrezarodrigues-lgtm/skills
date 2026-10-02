# Estilo do usuário (medido nas referências)

Padrão para os vídeos deste usuário. Substitui `estilo-padrao.md`. Os vídeos estão em
`referencias/` (360×640, então toda medida em px abaixo já foi convertida para 1080×1920,
fator 3×). Medição: varredura de pixels brancos em 2 quadros por segundo, mediana.

| arquivo | duração | cortes detectados | plano médio | loudness | trilha |
|---|---|---|---|---|---|
| `ref1.mp4` | 129,0s | 7 | 16,1s | −23,5 LUFS, pico −1,0 dB | não (10 silêncios ≥0,3s) |
| `ref2.mp4` | 56,4s | 18 | 3,0s | −19,9 LUFS, pico 0,0 dB | não (2 silêncios) |
| `ref3.mp4` | 34,3s | 21 | 1,6s | −21,8 LUFS, pico −4,9 dB | sim, sob a voz (1 silêncio) |

As três são anúncios de tratamento de emagrecimento com uma mulher falando para a câmera.
Elas formam **duas famílias**. Perguntar ao usuário qual usar se o pedido não disser.

---

## Família A: UGC / criadora falando (ref1, ref2)

Cara de vídeo orgânico de Instagram. Selfie ou celular apoiado, luz de casa, roupa do
dia a dia. A venda vem no meio da conversa.

**Legenda**
- Serifada, branca, sem caixa, sem contorno visível, sombra leve. Fonte próxima:
  Playfair Display ou DM Serif Display (Google Fonts). Peso regular/semibold.
- **1 a 3 palavras por vez**, cada bloco entra com fade rápido (~4 quadros). Nunca frase
  inteira.
- Altura das letras: 14px em 640 → **~42px em 1920**, corpo da fonte ~62px.
- Centro vertical: **78,3%** (ref1) e **71,7%** (ref2). Usar ~75% e ajustar para não
  cobrir mãos/produto.
- Quebra em 2 linhas só quando a palavra é longa ("acompanhamento nutricional").

**Gancho (primeiros 2 a 3s)**
- Texto grande no topo (8% a 30% da altura), sobre o cabelo, nunca sobre o rosto.
- ref1: sans bold branca, a palavra-chave em amarelo ("primeira **semana**") e um
  rabisco manuscrito pequeno embaixo ("com medicação") com seta.
- ref2: fonte manuscrita amarela, alinhada à esquerda, com estrelinhas piscando.
- O texto se monta palavra a palavra e some quando a fala começa a desenvolver.

**Elementos fixos**
- Cupom persistente logo abaixo da legenda (ref2: "CUPOM: POXABARI", sans bold caixa
  alta, amarelo-claro, ~36px, centro a ~79%). Fica o vídeo todo depois do gancho.

**Inserts**
- **Meme / reação** em retângulo pequeno no topo (ref1: Patrick com to-do list, "55
  fries"), cerca de 1 a 2s, ocupando ~70% da largura entre 7% e 30% da altura.
- **Card de benefícios** tipo print de site, fundo branco, ícone + texto em 3 linhas,
  no topo (ref2 aos 36s, "Suporte clínico ilimitado via WhatsApp...").
- Produto na mão é o B-roll: ela mostra a caneta, a bolsa, o copo.

**Corte e enquadramento**
- Jump cut removendo pausa. ref2 corta a cada ~3s, ref1 deixa trechos longos.
- Troca de zoom entre os cortes (largo ↔ close), alternando para esconder o jump cut.
- Os primeiros 8s da ref2 são planos rápidos de "pensando" (mão no queixo, anotando)
  antes de ela começar a falar: micro-cena de gancho.

**Áudio**: só voz, sem trilha.

---

## Família B: anúncio produzido / depoimento (ref3)

Gravação com câmera boa, luz montada, cliente real dando depoimento. Ritmo de anúncio
pago: plano médio de 1,6s.

**Legenda**
- Sans (Inter / Graphik), preta, dentro de **pílula branca** de cantos arredondados.
- Pílula com ~96px de altura em 1920, centro vertical a **70,3%**, largura justa ao
  texto. Frase curta de 3 a 6 palavras por vez.
- Some quando entra um insert grande.

**Gancho**: pergunta no topo (~15% a 22%), sans branca em pílula escura translúcida,
palavra a palavra ("Sem tempo para emagrecer?").

**Lower third de identidade** (2s a 4s): nome grande sans bold branco ("Leticia") e
resultado embaixo menor ("15kg em 6 meses"), à esquerda, em ~55%.

**Insert de frase-chave**: sans bold branca grande, **alinhada à esquerda**, 2 a 3
linhas, entre 57% e 70%, palavras aparecendo em sequência ("Se fosse presencial / eu
teria desistido"). A legenda some enquanto ele está na tela.

**Antes / Depois**: tela dividida ao meio, etiqueta pequena em chip ("Antes",
"Depois") no topo de cada metade.

**B-roll com benefício**: celular mostrando o app, entrega na porta, comida, consulta.
Sobre cada um, um **chip verde-escuro** (`~#1F3A2E` a 90%) com o benefício em sans
branca, 2 linhas, centralizado em ~40%. Ex.: "Tratamento completo de emagrecimento",
"Entrega em casa com frete grátis".

**Cartela final (últimos ~4s)**: fundo gradiente pastel (pêssego → menta), marca no
topo, "Comece ainda hoje" grande, preço em destaque ("R$ 349,99/mês" com centavos
pequenos), botão CTA laranja com gradiente e sombra ("Dê o primeiro passo"), aviso
legal em letra miúda embaixo.

**Áudio**: voz + trilha baixa contínua.

---

## O que vale para as duas

- Vertical 9:16, uma pessoa falando para a câmera como base.
- Legenda sempre presente, curta, no terço inferior (70% a 78%), nunca sobre o rosto.
- Gancho visual escrito nos 3 primeiros segundos.
- Produto ou benefício aparece concreto: na mão, na tela do celular, em chip.
- Termina em CTA claro (cupom, link na bio ou cartela com preço).
