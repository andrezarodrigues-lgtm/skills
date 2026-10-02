# Preferências de comunicação

- Responda sempre em português do Brasil (PT-BR), independentemente do idioma da pergunta.

# Skills de edição de vídeo

Instaladas em `.claude/skills/`:

- `video-use` (github.com/browser-use/video-use @ b877063): corte por transcrição, color grade, legendas, overlays via ffmpeg. Helpers em `.claude/skills/video-use/helpers/`. Dependências Python: `pip install requests librosa matplotlib pillow numpy`. Transcrição exige `ELEVENLABS_API_KEY` (variável de ambiente ou `.claude/skills/video-use/.env`, nunca commitado).
- `remotion-motion-graphics` (github.com/haidrrrry/claude-remotion-skill @ 1dcbe5e): motion graphics em Remotion. Exemplos de composição em `examples/`.

Objetivo do projeto: transformar vídeos longos em anúncios curtos, seguindo as referências visuais que o usuário fornecer. Saídas de edição vão sempre em `<pasta_dos_videos>/edit/`, nunca dentro das pastas das skills.
- `reels-anuncio` (método próprio): pipeline de Reel/anúncio vertical com punch-in ancorado no rosto, legenda por palavra e inserts que significam a palavra falada. Marcas em `.claude/skills/reels-anuncio/references/marcas/` (hoje: ContrataPJ). Cliente novo = arquivo novo de marca, o método não muda.
