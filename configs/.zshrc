function command_exists() {
  hash "$1" &>/dev/null
}

# ─── Antigen (oh-my-zsh) ───────────────────────────────────────────────────
if command_exists brew; then
  source $(brew --prefix)/share/antigen/antigen.zsh
else
  source /usr/local/share/antigen/antigen.zsh
fi

antigen use oh-my-zsh

antigen bundle git
antigen bundle git-extras
antigen bundle git-flow
antigen bundle python
antigen bundle pip
antigen bundle node
antigen bundle npm
antigen bundle command-not-found
antigen bundle zsh-users/zsh-syntax-highlighting

antigen bundle mafredri/zsh-async@main
antigen bundle denysdovhan/spaceship-prompt

antigen apply

# ─── Aliases ───────────────────────────────────────────────────────────────
[ -f ~/.aliases ] && source ~/.aliases

# ─── SSH Agent ─────────────────────────────────────────────────────────────
eval "$(ssh-agent -s)" &>/dev/null

# ─── fnm (Node.js 버전 관리) ──────────────────────────────────────────────
FNM_PATH="$HOME/Library/Application Support/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env)"
fi
eval "$(fnm env --use-on-cd)"

# ─── pyenv (Python 버전 관리) ─────────────────────────────────────────────
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
source $(brew --prefix autoenv)/activate.sh &>/dev/null || true

# ─── jenv (Java 버전 관리) ────────────────────────────────────────────────
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

# ─── Homebrew PATH ─────────────────────────────────────────────────────────
export PATH=/opt/homebrew/bin:$PATH

# ─── bun ───────────────────────────────────────────────────────────────────
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# ─── 환경변수 (민감 정보는 ~/.zshrc.local 에 작성) ──────────────────────
# export ANTHROPIC_API_KEY="..."  ← ~/.zshrc.local 에 넣으세요
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# ─── rustup / cargo ────────────────────────────────────────────────────────
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
