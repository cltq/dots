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

# zsh and prompt related
alias rl='source ~/.zshrc'
alias sz='source ~/.zshrc'
alias ss-catpuccin='starship preset catppuccin-powerline -o ~/.config/starship.toml'
alias ss-jetpack='starship preset jetpack -o ~/.config/starship.toml'
alias ss-tokyonight='starship preset tokyo-night -o ~/.config/starship.toml'

# Arch Linux Pacman related
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
       shift
       sudo pacman -Syu
       ;;
       s|search)
       shift
       sudo pacman -Ss "$@"
       ;;
       rs|repo-search)
       shift
       sudo pacman -Si "$@"
       ;;
    esac
}

# Prompts
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
eval "$(starship init zsh)"
