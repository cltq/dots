# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# ZSH_THEME=""

plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-autocomplete)

source $ZSH/oh-my-zsh.sh

_exec_zsh() {
  exec zsh
}

# zsh and prompt related
alias rl-exec=_exec_zsh
alias sz-exec=_exec_zsh
alias rl='source ~/.zshrc'
alias sz='source ~/.zshrc'
alias ss-catpuccin='starship preset catppuccin-powerline -o ~/.config/starship.toml'
alias ss-jetpack='starship preset jetpack -o ~/.config/starship.toml'
alias ss-tokyonight='starship preset tokyo-night -o ~/.config/starship.toml'

# Arch Linux Pacman and AUR Related
pm() {
  case "$1" in
    i|install|get)
      shift
      sudo pacman -S "$@"
      ;;

    rm|r|remove|uninstall)
      shift
      sudo pacman -R "$@"
      ;;

    rd|remove-deps)
      shift
      sudo pacman -Rns "$@"
      ;;

    u|update)
      updates=$(pacman -Qu)

      if [ -z "$updates" ]; then
        echo "System is already up to date."
        return
      fi

      echo "Updating system..."
      sudo pacman -Syu

      echo ""
      echo "$updates" | grep -E '^(linux|linux-lts|linux-zen|systemd|glibc|mesa|nvidia)' >/dev/null
      if [ $? -eq 0 ]; then
        echo "⚠️  Important system packages were updated:"
        echo "$updates" | grep -E '^(linux|linux-lts|linux-zen|systemd|glibc|mesa|nvidia)'
        echo ""
        echo "👉 A system restart is recommended."
      fi
      ;;

    s|search)
      shift
      pacman -Ss "$@"
      ;;

    rs|repo-search)
      shift
      pacman -Si "$@"
      ;;

    aur)
      shift
      if command -v yay >/dev/null 2>&1; then
        yay "$@"
      else
        echo "yay is not installed."
        read -q "REPLY?Install yay now? [y/N]: "
        echo

        if [[ "$REPLY" =~ ^[Yy]$ ]]; then
          echo "Installing yay..."

          sudo pacman -S --needed git base-devel || return

          tmpdir=$(mktemp -d)
          git clone https://aur.archlinux.org/yay.git "$tmpdir/yay" || return
          cd "$tmpdir/yay" || return

          makepkg -si --noconfirm || return

          cd ~
          rm -rf "$tmpdir"

          echo "yay installed successfully."
          echo "Retrying command..."
          yay "$@"
        else
          echo "Cancelled."
        fi
      fi
      ;;

    *)
      echo "Usage:"
      echo "  pm i <pkg>        # install (repo)"
      echo "  pm r <pkg>        # remove"
      echo "  pm rd <pkg>       # remove with deps"
      echo "  pm u              # update system"
      echo "  pm s <query>      # search repo"
      echo "  pm rs <pkg>       # repo info"
      echo "  pm aur <args>     # use yay (AUR + repo)"
      ;;
  esac
}

_dotfiles_cmd() {
  DOTFILES_DIR="$HOME"

  if [ ! -d "$DOTFILES_DIR/.git" ]; then
    echo "❌ $DOTFILES_DIR is not a git repo"
    return 1
  fi

  case "$1" in
    update|u)
      shift
      msg="$*"
      [ -z "$msg" ] && echo "❌ Usage: df update \"message\"" && return 1

      git -C "$DOTFILES_DIR" add -A
      git -C "$DOTFILES_DIR" commit -m "$msg"
      git -C "$DOTFILES_DIR" push
      ;;

    pull|p)
      git -C "$DOTFILES_DIR" stash push -m "auto-stash" >/dev/null 2>&1
      git -C "$DOTFILES_DIR" pull --rebase
      git -C "$DOTFILES_DIR" stash pop >/dev/null 2>&1
      ;;

    status|s)
      git -C "$DOTFILES_DIR" status
      ;;

    log|l)
      git -C "$DOTFILES_DIR" log --oneline --graph --decorate -n 10
      ;;

    diff|d)
      git -C "$DOTFILES_DIR" diff
      ;;

    edit|e)
      ${EDITOR:-nano} "$DOTFILES_DIR"
      ;;

    *)
      echo "Dotfiles command:"
      echo "  dotfiles update \"msg\""
      echo "  dotfiles pull"
      echo "  dotfiles status"
      echo "  dotfiles log"
      echo "  dotfiles diff"
      echo "  dotfiles edit"
      ;;
  esac
}

# two command names → same function
alias fumidots='_dotfiles_cmd'
alias dotfiles='_dotfiles_cmd'

# Prompts
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
eval "$(starship init zsh)"
