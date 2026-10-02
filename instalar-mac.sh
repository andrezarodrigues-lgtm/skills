#!/bin/bash
# Instala o ambiente de edição de vídeo no macOS.
# Uso: abrir o Terminal e rodar  bash instalar-mac.sh
set -e

echo "1/5 Programas base (Homebrew, git, ffmpeg, node, python)..."
command -v brew >/dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
brew install git ffmpeg node python

echo "2/5 Claude Code..."
command -v claude >/dev/null || curl -fsSL https://claude.ai/install.sh | bash

echo "3/5 Repositório com as skills..."
DIR="$HOME/skills"
[ -d "$DIR" ] || git clone https://github.com/andrezarodrigues-lgtm/skills "$DIR"
cd "$DIR"
git fetch origin
git checkout claude/loving-knuth-jq4nd5
git pull

echo "4/5 Bibliotecas Python..."
python3 -m pip install --user --break-system-packages requests librosa matplotlib pillow numpy "opencv-python-headless==4.10.0.84" faster-whisper

echo "5/5 Conferindo..."
ffmpeg -version | head -1; node -v; python3 --version; claude --version || echo "abra um Terminal novo para o comando claude aparecer"

echo
echo "Pronto. Para editar:  cd $DIR  e depois  claude"
