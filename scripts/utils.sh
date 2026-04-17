#!/usr/bin/env bash

set -e

# -------- Detect package manager --------
if command -v pacman >/dev/null 2>&1; then
  PKG_MANAGER="pacman"
else
  echo "❌ This script currently supports Arch-based systems only."
  exit 1
fi

# -------- Helpers --------
install_pkg() {
  sudo pacman -S --noconfirm --needed "$@"
}

ensure_base_deps() {
  echo "🔍 Checking base dependencies..."

  command -v git >/dev/null 2>&1 || install_pkg git
  command -v curl >/dev/null 2>&1 || install_pkg curl

  if ! command -v zsh >/dev/null 2>&1; then
    echo "⚠️ zsh not found. Installing..."
    install_pkg zsh
  fi
}

install_important() {
  echo "📦 Installing important packages..."

  install_pkg ttf-jetbrains-mono ttf-jetbrains-mono-nerd starship

  echo "✅ Done."
}

install_omz() {
  ensure_base_deps

  if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh already installed."
    return
  fi

  echo "🚀 Installing Oh My Zsh..."
  RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  echo "✅ Oh My Zsh installed."
}

install_omz_plugins() {
  ensure_base_deps

  ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

  echo "🔌 Installing plugins..."

  # zsh-autosuggestions
  if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions \
      "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
  fi

  # zsh-syntax-highlighting
  if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting \
      "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
  fi

  # zsh-autocomplete
  if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autocomplete" ]; then
    git clone https://github.com/marlonrichert/zsh-autocomplete \
      "$ZSH_CUSTOM/plugins/zsh-autocomplete"
  fi

  echo "✅ Plugins installed."
  echo "👉 Add this to your ~/.zshrc:"
  echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-autocomplete)'
}

# -------- CLI --------
case "$1" in
  install)
    case "$2" in
      omz)
        install_omz
        ;;
      omz-plugins)
        install_omz_plugins
        ;;
      important)
        ensure_base_deps
        install_important
        ;;
      *)
        echo "Unknown install target: $2"
        echo "Usage:"
        echo "  utils.sh install omz"
        echo "  utils.sh install omz-plugins"
        echo "  utils.sh install important"
        ;;
    esac
    ;;
  *)
    echo "Usage:"
    echo "  utils.sh install omz"
    echo "  utils.sh install omz-plugins"
    echo "  utils.sh install important"
    ;;
esac
