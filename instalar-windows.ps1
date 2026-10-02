# Instala o ambiente de edição de vídeo no Windows.
# Uso: abrir o PowerShell e rodar  powershell -ExecutionPolicy Bypass -File instalar-windows.ps1
$ErrorActionPreference = "Stop"

function Atualiza-Path {
  $env:Path = [Environment]::GetEnvironmentVariable("Path","Machine") + ";" +
              [Environment]::GetEnvironmentVariable("Path","User")
}

Write-Host "1/5 Programas base (git, ffmpeg, node, python)..."
foreach ($id in "Git.Git","Gyan.FFmpeg","OpenJS.NodeJS.LTS","Python.Python.3.12") {
  winget install --id $id -e --accept-source-agreements --accept-package-agreements --silent
}
Atualiza-Path

Write-Host "2/5 Claude Code..."
irm https://claude.ai/install.ps1 | iex
Atualiza-Path

Write-Host "3/5 Repositório com as skills..."
$dir = Join-Path $HOME "skills"
if (-not (Test-Path $dir)) { git clone https://github.com/andrezarodrigues-lgtm/skills $dir }
Set-Location $dir
git fetch origin
git checkout claude/loving-knuth-jq4nd5
git pull

Write-Host "4/5 Bibliotecas Python..."
python -m pip install --upgrade pip
python -m pip install requests librosa matplotlib pillow numpy "opencv-python-headless==4.10.0.84" faster-whisper

Write-Host "5/5 Conferindo..."
ffmpeg -version | Select-Object -First 1
node -v
python --version
claude --version

Write-Host ""
Write-Host "Pronto. Para editar:  cd $dir  e depois  claude"
