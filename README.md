# 🍚 My Arch Rice

> My personal dotfiles for Arch Linux

## 🛠️ Stack

| Tool | Name |
|------|------|
| OS | Arch Linux |
| DE | KDE Plasma |
| Terminal | Kitty |
| Shell | Zsh + Starship |
| Editor | Neovim (LazyVim) |
| Multiplexer | Tmux |
| Monitor | Btop |

## 📦 Installation
```bash
git clone --bare https://github.com/Souheib-h/My-arch-rice.git $HOME/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles checkout
dotfiles config --local status.showUntrackedFiles no
```

## 🔌 Tmux Plugins
Plugins are managed via [tpm](https://github.com/tmux-plugins/tpm). After installing, press `prefix + I` to install.
