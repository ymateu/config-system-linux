#!/usr/bin/env bash

# ============================================================
#                    MANJARO DEV SETUP
#                         MATEU
# ============================================================

set -euo pipefail

# ------------------------------------------------------------
# CORES
# ------------------------------------------------------------

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
RESET='\033[0m'

# ------------------------------------------------------------
# FUNÇÕES
# ------------------------------------------------------------

log() {
    echo -e "${CYAN}[INFO]${RESET} $1"
}

success() {
    echo -e "${GREEN}[OK]${RESET} $1"
}

warning() {
    echo -e "${YELLOW}[AVISO]${RESET} $1"
}

error() {
    echo -e "${RED}[ERRO]${RESET} $1"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# ------------------------------------------------------------
# VERIFICAÇÃO
# ------------------------------------------------------------

if [[ "${EUID}" -eq 0 ]]; then
    error "Não execute este script como root."
    exit 1
fi

if ! command_exists pacman; then
    error "Este script foi desenvolvido para Manjaro/Arch Linux."
    exit 1
fi

echo
echo -e "${CYAN}"
cat <<'EOF'

 __  __    _    _____ _____ _   _ 
|  \/  |  / \  |_   _| ____| | | |
| |\/| | / _ \   | | |  _| | | | |
| |  | |/ ___ \  | | | |___| |_| |
|_|  |_/_/   \_\ |_| |_____|\___/ 

              M A T E U

EOF
echo -e "${RESET}"

log "Iniciando configuração do ambiente de desenvolvimento..."

# ------------------------------------------------------------
# ATUALIZAÇÃO DO SISTEMA
# ------------------------------------------------------------

log "Atualizando o sistema..."

sudo pacman -Syu --needed

# ------------------------------------------------------------
# PACOTES BÁSICOS
# ------------------------------------------------------------

log "Instalando ferramentas básicas..."

sudo pacman -S --needed \
    base-devel \
    git \
    curl \
    wget \
    unzip \
    zip \
    tar \
    gzip \
    bzip2 \
    xz \
    rsync \
    openssh \
    tree \
    which \
    file \
    less \
    nano \
    vim \
    neovim \
    htop \
    btop \
    fastfetch \
    jq \
    yq \
    ripgrep \
    fd \
    fzf \
    tmux \
    zoxide \
    eza \
    bat \
    git-delta \
    ncdu

success "Ferramentas básicas instaladas."

# ------------------------------------------------------------
# PYTHON
# ------------------------------------------------------------

log "Instalando Python e ferramentas..."

sudo pacman -S --needed \
    python \
    python-pip \
    python-pipx \
    python-virtualenv

success "Python instalado."

# ------------------------------------------------------------
# NODE.JS
# ------------------------------------------------------------

log "Instalando Node.js LTS e npm..."

# Node.js LTS atual do repositório Manjaro/Arch
sudo pacman -S --needed \
    nodejs-lts-krypton \
    npm

success "Node.js LTS e npm instalados."

# ------------------------------------------------------------
# YARN
# ------------------------------------------------------------

log "Instalando Yarn..."

sudo npm install --global yarn

success "Yarn instalado."

# ------------------------------------------------------------
# KITTY
# ------------------------------------------------------------

log "Instalando Kitty..."

sudo pacman -S --needed kitty

KITTY_CONFIG_DIR="$HOME/.config/kitty"
mkdir -p "$KITTY_CONFIG_DIR"

# Fonte com suporte a ligaduras
# JetBrains Mono é uma boa escolha para desenvolvimento.
sudo pacman -S --needed ttf-jetbrains-mono

cat > "$KITTY_CONFIG_DIR/kitty.conf" <<'EOF'
# ============================================================
# KITTY - MATEU
# ============================================================

# Fonte
font_family JetBrains Mono
font_size 12.0

# Ligaduras
disable_ligatures never

# Transparência
background_opacity 0.88

# Blur
background_blur 15

# Cursor
cursor_shape block
cursor_blink_interval 0

# Scrollback
scrollback_lines 10000

# Abas
tab_bar_edge top
tab_bar_style powerline

# Atalhos úteis
map ctrl+shift+enter new_window_with_cwd
map ctrl+shift+t new_tab_with_cwd
map ctrl+shift+w close_window
map ctrl+shift+right next_tab
map ctrl+shift+left previous_tab

# Copiar / colar
map ctrl+shift+c copy_to_clipboard
map ctrl+shift+v paste_from_clipboard

# Preferência de terminal
shell_integration enabled
EOF

success "Kitty configurado."

# ------------------------------------------------------------
# KITTY COMO TERMINAL PADRÃO
# ------------------------------------------------------------

log "Configurando Kitty como terminal padrão..."

mkdir -p "$HOME/.config"

# xdg-terminal-exec, quando disponível
if command_exists xdg-terminal-exec; then
    mkdir -p "$HOME/.config"
    echo "kitty.desktop" > "$HOME/.config/xdg-terminals.list"
fi

# GNOME
if command_exists gsettings; then
    gsettings set org.gnome.desktop.default-applications.terminal exec kitty 2>/dev/null || true
fi

# XFCE
if command_exists xfconf-query; then
    xfconf-query \
        -c xfce4-session \
        -p /general/PreferredTerminal \
        -s kitty \
        2>/dev/null || true
fi

# KDE Plasma
if command_exists kwriteconfig6; then
    kwriteconfig6 \
        --file kdeglobals \
        --group General \
        --key TerminalApplication \
        kitty \
        2>/dev/null || true
fi

# Preferência pessoal
touch "$HOME/.profile"

if ! grep -q '^export TERMINAL=kitty$' "$HOME/.profile"; then
    echo 'export TERMINAL=kitty' >> "$HOME/.profile"
fi

success "Kitty configurado como terminal preferencial."

# ------------------------------------------------------------
# ZSH
# ------------------------------------------------------------

log "Instalando Zsh..."

sudo pacman -S --needed zsh

success "Zsh instalado."

# ------------------------------------------------------------
# OH MY ZSH
# ------------------------------------------------------------

log "Instalando Oh My Zsh..."

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then

    RUNZSH=no \
    CHSH=no \
    KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

fi

success "Oh My Zsh instalado."

# ------------------------------------------------------------
# PLUGINS DO ZSH
# ------------------------------------------------------------

log "Instalando plugins do Zsh..."

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
    git clone \
        https://github.com/zsh-users/zsh-autosuggestions \
        "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
    git clone \
        https://github.com/zsh-users/zsh-syntax-highlighting.git \
        "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

success "Plugins do Zsh instalados."

# ------------------------------------------------------------
# POWERLEVEL10K
# ------------------------------------------------------------

log "Instalando Powerlevel10k..."

if [[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]]; then
    git clone --depth=1 \
        https://github.com/romkatv/powerlevel10k.git \
        "$ZSH_CUSTOM/themes/powerlevel10k"
fi

success "Powerlevel10k instalado."

# ------------------------------------------------------------
# SDKMAN
# ------------------------------------------------------------

log "Instalando SDKMAN..."

if [[ ! -d "$HOME/.sdkman" ]]; then
    curl -s "https://get.sdkman.io" | bash
fi

# Carrega SDKMAN
if [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

success "SDKMAN instalado."

# ------------------------------------------------------------
# JAVA 17
# ------------------------------------------------------------

log "Instalando Java 17..."

if command_exists sdk; then
    sdk install java 17.0.16-tem || true
fi

success "Java 17 configurado."

# ------------------------------------------------------------
# JAVA 21
# ------------------------------------------------------------

log "Instalando Java 21..."

if command_exists sdk; then
    sdk install java 21.0.8-tem || true
    sdk default java 21.0.8-tem || true
fi

success "Java 21 configurado como padrão."

# ------------------------------------------------------------
# MAVEN
# ------------------------------------------------------------

log "Instalando Maven..."

if command_exists sdk; then
    sdk install maven || true
fi

success "Maven configurado."

# ------------------------------------------------------------
# GRADLE
# ------------------------------------------------------------

log "Instalando Gradle..."

if command_exists sdk; then
    sdk install gradle || true
fi

success "Gradle configurado."

# ------------------------------------------------------------
# VS CODE
# ------------------------------------------------------------

log "Instalando Visual Studio Code..."

sudo pacman -S --needed code

success "VS Code instalado."

# ------------------------------------------------------------
# NETBEANS
# ------------------------------------------------------------

log "Instalando NetBeans..."

sudo pacman -S --needed netbeans

success "NetBeans instalado."

# ------------------------------------------------------------
# DOCKER
# ------------------------------------------------------------

log "Instalando Docker..."

sudo pacman -S --needed \
    docker \
    docker-compose \
    docker-buildx

sudo systemctl enable --now docker.service

# Adiciona usuário ao grupo Docker
if ! groups "$USER" | grep -q '\bdocker\b'; then
    sudo usermod -aG docker "$USER"
    warning "Seu usuário foi adicionado ao grupo docker."
    warning "Pode ser necessário sair e entrar novamente na sessão."
fi

success "Docker configurado."

# ------------------------------------------------------------
# POSTGRESQL
# ------------------------------------------------------------

log "Instalando PostgreSQL..."

sudo pacman -S --needed postgresql

if [[ ! -d "/var/lib/postgres/data/base" ]]; then
    sudo -u postgres initdb \
        --locale=en_US.UTF-8 \
        --encoding=UTF8 \
        -D /var/lib/postgres/data
fi

sudo systemctl enable --now postgresql.service

success "PostgreSQL configurado."

# ------------------------------------------------------------
# MYSQL
# ------------------------------------------------------------

log "Instalando MySQL..."

sudo pacman -S --needed mysql

if [[ ! -d "/var/lib/mysql/mysql" ]]; then
    sudo mysqld --initialize-insecure \
        --user=mysql \
        --datadir=/var/lib/mysql
fi

sudo systemctl enable --now mysqld.service

success "MySQL configurado."

# ------------------------------------------------------------
# MONGODB
# ------------------------------------------------------------

log "Instalando MongoDB..."

if command_exists pamac; then
    pamac build --no-confirm mongodb-bin || \
        warning "Não foi possível instalar mongodb-bin automaticamente."
else
    warning "Pamac não encontrado. MongoDB não foi instalado."
fi

if command_exists mongod; then
    sudo systemctl enable --now mongodb.service 2>/dev/null || \
        sudo systemctl enable --now mongod.service 2>/dev/null || true
fi

success "MongoDB processado."

# ------------------------------------------------------------
# POSTMAN
# ------------------------------------------------------------

log "Instalando Postman..."

if command_exists pamac; then
    pamac build --no-confirm postman-bin || \
        warning "Não foi possível instalar o Postman automaticamente."
else
    warning "Pamac não encontrado. Postman não foi instalado."
fi

success "Postman processado."

# ------------------------------------------------------------
# GOOGLE CHROME
# ------------------------------------------------------------

log "Instalando Google Chrome..."

if command_exists pamac; then
    pamac build --no-confirm google-chrome || \
        warning "Não foi possível instalar o Google Chrome automaticamente."
else
    warning "Pamac não encontrado. Google Chrome não foi instalado."
fi

success "Google Chrome processado."

# ------------------------------------------------------------
# GIT
# ------------------------------------------------------------

log "Configurando Git..."

git config --global user.name "Mateus"
git config --global user.email "mateusantonioofc@gmail.com"

git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global core.editor "nvim"

success "Git configurado."

# ------------------------------------------------------------
# ZSHRC
# ------------------------------------------------------------

log "Configurando .zshrc..."

ZSHRC="$HOME/.zshrc"

# Backup
if [[ -f "$ZSHRC" ]]; then
    cp "$ZSHRC" "$ZSHRC.backup.$(date +%Y%m%d_%H%M%S)"
fi

cat > "$ZSHRC" <<'EOF'
# ============================================================
# MATEU - ZSH CONFIG
# ============================================================

export TERMINAL=kitty

# ------------------------------------------------------------
# OH MY ZSH
# ------------------------------------------------------------

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
    git
    docker
    sudo
    history
    colored-man-pages
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

# ------------------------------------------------------------
# SDKMAN
# ------------------------------------------------------------

export SDKMAN_DIR="$HOME/.sdkman"

if [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
    source "$SDKMAN_DIR/bin/sdkman-init.sh"
fi

# ------------------------------------------------------------
# ZOXIDE
# ------------------------------------------------------------

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

# ------------------------------------------------------------
# ALIASES
# ------------------------------------------------------------

alias ll='eza -lah --icons'
alias la='eza -a --icons'
alias ls='eza --icons'

alias cat='bat'
alias grep='rg'

alias ..='cd ..'
alias ...='cd ../..'

alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

alias dc='docker compose'
alias dps='docker ps'
alias dimg='docker images'

alias py='python'
alias python3='python'

alias ports='ss -tulpn'

alias update='sudo pacman -Syu'

# ------------------------------------------------------------
# PROJETOS
# ------------------------------------------------------------

export PROJETOS="$HOME/Documentos/PROJETOS"

alias projetos='cd "$PROJETOS"'
alias java='cd "$PROJETOS/Java"'
alias python-projects='cd "$PROJETOS/Python"'
alias javascript='cd "$PROJETOS/JavaScript"'

# ------------------------------------------------------------
# FASTFETCH
# ------------------------------------------------------------

if command -v fastfetch >/dev/null 2>&1; then
    fastfetch
fi

# ------------------------------------------------------------
# POWERLEVEL10K
# ------------------------------------------------------------

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOF

success ".zshrc configurado."

# ------------------------------------------------------------
# POWERLEVEL10K CONFIG
# ------------------------------------------------------------

log "Criando configuração inicial do Powerlevel10k..."

cat > "$HOME/.p10k.zsh" <<'EOF'
# Generated basic Powerlevel10k configuration

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    os_icon
    dir
    vcs
)

typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status
    command_execution_time
    background_jobs
    time
)

typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique

typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=4

typeset -g POWERLEVEL9K_VCS_SHOW_INCOMING_CHANGES=true
typeset -g POWERLEVEL9K_VCS_SHOW_OUTGOING_CHANGES=true

typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M}'
EOF

success "Powerlevel10k configurado."

# ------------------------------------------------------------
# DIRETÓRIO DE DOCUMENTOS
# ------------------------------------------------------------

log "Criando estrutura de projetos..."

DOCUMENTS_DIR="$(xdg-user-dir DOCUMENTS 2>/dev/null || true)"

if [[ -z "$DOCUMENTS_DIR" || ! -d "$DOCUMENTS_DIR" ]]; then
    if [[ -d "$HOME/Documentos" ]]; then
        DOCUMENTS_DIR="$HOME/Documentos"
    elif [[ -d "$HOME/Documents" ]]; then
        DOCUMENTS_DIR="$HOME/Documents"
    else
        DOCUMENTS_DIR="$HOME/Documentos"
        mkdir -p "$DOCUMENTS_DIR"
    fi
fi

PROJECTS_DIR="$DOCUMENTS_DIR/PROJETOS"

mkdir -p \
    "$PROJECTS_DIR/Java" \
    "$PROJECTS_DIR/Python" \
    "$PROJECTS_DIR/JavaScript"

success "Estrutura criada:"
echo
echo "  $PROJECTS_DIR/"
echo "  ├── Java/"
echo "  ├── Python/"
echo "  └── JavaScript/"
echo

# ------------------------------------------------------------
# DIRETÓRIOS AUXILIARES
# ------------------------------------------------------------

mkdir -p \
    "$HOME/.config" \
    "$HOME/.local/bin" \
    "$HOME/.cache"

# ------------------------------------------------------------
# PATH
# ------------------------------------------------------------

if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.zshrc"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
fi

# ------------------------------------------------------------
# ZSH COMO SHELL PADRÃO
# ------------------------------------------------------------

log "Configurando Zsh como shell padrão..."

ZSH_PATH="$(command -v zsh)"

if [[ -n "$ZSH_PATH" ]]; then
    CURRENT_SHELL="$(getent passwd "$USER" | cut -d: -f7)"

    if [[ "$CURRENT_SHELL" != "$ZSH_PATH" ]]; then
        chsh -s "$ZSH_PATH"
        success "Zsh definido como shell padrão."
        warning "Faça logout/login para aplicar completamente."
    else
        success "Zsh já é o shell padrão."
    fi
fi

# ------------------------------------------------------------
# INFORMAÇÕES FINAIS
# ------------------------------------------------------------

echo
echo -e "${GREEN}"
cat <<'EOF'

============================================================
                 CONFIGURAÇÃO CONCLUÍDA
============================================================

 Terminal:
   Kitty

 Shell:
   Zsh + Oh My Zsh + Powerlevel10k

 Linguagens:
   Java 17
   Java 21
   Python 3
   JavaScript / Node.js LTS

 Build:
   Maven
   Gradle
   npm
   Yarn

 Bancos:
   PostgreSQL
   MySQL
   MongoDB

 Containers:
   Docker
   Docker Compose

 IDE / Editores:
   VS Code
   NetBeans

 Ferramentas:
   Git
   Git Delta
   fzf
   ripgrep
   fd
   jq
   yq
   zoxide
   eza
   bat
   btop

 Navegadores:
   Google Chrome

 Projetos:
   ~/Documentos/PROJETOS/
   ├── Java/
   ├── Python/
   └── JavaScript/

============================================================
                     M A T E U
============================================================

EOF
echo -e "${RESET}"

warning "Recomenda-se reiniciar a sessão (logout/login)."
warning "Isso garante que Zsh, grupo Docker e configurações do ambiente sejam aplicados."

success "Setup finalizado!"
