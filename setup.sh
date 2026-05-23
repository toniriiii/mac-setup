#!/bin/bash
# 새 맥 초기 세팅 스크립트
# 사용법: curl 또는 git clone 후 bash setup.sh

set -e

# ─── 색상 ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log()  { echo -e "${GREEN}[✓]${NC} $1"; }
info() { echo -e "${BLUE}[→]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
fail() { echo -e "${RED}[✗]${NC} $1"; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   Mac 초기 세팅 시작                   ${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# ─── 1. Xcode Command Line Tools ──────────────────────────────────────────
info "Xcode Command Line Tools 확인 중..."
if ! xcode-select -p &>/dev/null; then
  info "Xcode Command Line Tools 설치 중... (팝업창에서 '설치' 클릭)"
  xcode-select --install
  # 설치 완료될 때까지 대기
  until xcode-select -p &>/dev/null; do
    sleep 5
  done
  log "Xcode Command Line Tools 설치 완료"
else
  log "Xcode Command Line Tools 이미 설치됨"
fi

# ─── 2. Homebrew ───────────────────────────────────────────────────────────
info "Homebrew 확인 중..."
if ! command -v brew &>/dev/null; then
  info "Homebrew 설치 중..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Apple Silicon 경로 설정
  if [[ "$(uname -m)" == "arm64" ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  log "Homebrew 설치 완료"
else
  log "Homebrew 이미 설치됨"
  brew update
fi

# ─── 3. Brewfile로 패키지/앱 일괄 설치 ─────────────────────────────────────
info "Brewfile로 패키지 설치 중... (시간이 걸릴 수 있어요)"
brew bundle --file="$SCRIPT_DIR/Brewfile" || warn "일부 항목 설치 실패 (위 로그 확인)"
log "Brewfile 설치 완료"

# ─── 4. zsh 설정 (.zshrc) ─────────────────────────────────────────────────
info "zsh 설정 파일 복사 중..."
if [ -f "$HOME/.zshrc" ]; then
  cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d%H%M%S)"
  warn "기존 .zshrc 백업됨"
fi
cp "$SCRIPT_DIR/configs/.zshrc" "$HOME/.zshrc"
log ".zshrc 설정 완료"

# ─── 5. aliases ────────────────────────────────────────────────────────────
if [ -f "$SCRIPT_DIR/configs/.aliases" ]; then
  cp "$SCRIPT_DIR/configs/.aliases" "$HOME/.aliases"
  log ".aliases 복사 완료"
fi

# ─── 6. git 설정 ──────────────────────────────────────────────────────────
info "git 설정 중..."
echo ""
read -p "  git user.name  : " git_name
read -p "  git user.email : " git_email

if [ -n "$git_name" ]; then
  git config --global user.name "$git_name"
fi
if [ -n "$git_email" ]; then
  git config --global user.email "$git_email"
fi

git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
git config --global color.ui true
git config --global pull.rebase false
log "git 설정 완료"

# ─── 7. Node.js (fnm) ──────────────────────────────────────────────────────
info "Node.js LTS 설치 중 (fnm)..."
export PATH="$HOME/Library/Application Support/fnm:$PATH"
eval "$(fnm env 2>/dev/null)" || true
fnm install --lts 2>/dev/null && fnm use --lts 2>/dev/null || warn "fnm Node.js 설치 실패 — 수동으로 'fnm install --lts' 실행"
log "Node.js 설치 완료: $(node --version 2>/dev/null || echo '확인 필요')"

# ─── 8. bun ────────────────────────────────────────────────────────────────
info "bun 설치 중..."
if ! command -v bun &>/dev/null; then
  curl -fsSL https://bun.sh/install | bash
  log "bun 설치 완료"
else
  log "bun 이미 설치됨"
fi

# ─── 9. 완료 ──────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   설치 완료!                           ${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "  다음 단계:"
echo "  1. 터미널 재시작 (또는 'source ~/.zshrc') — zinit이 플러그인 자동 설치"
echo "  2. Java 설치 후 'jenv add <jdk경로>' 로 jenv에 등록"
echo "  3. Python 설치: pyenv install <버전>"
echo ""
warn "Google Chrome, Slack, Zoom, Cursor 는 sudo 필요 — 터미널에서 직접: brew install --cask google-chrome slack zoom cursor"
warn "회사 앱(Ivanti VPN, SentinelOne 등)은 IT팀 통해 설치"
echo ""
