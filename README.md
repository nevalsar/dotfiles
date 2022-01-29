# Dotfiles
My personal dotfiles.

## Setup
Install [GNU Stow](https://www.gnu.org/software/stow/).

- Clone the repo to your machine to home repository.
```sh
git clone https://github.com/nevinvalsaraj/dotfiles.git ~/.dotfiles
```

## Neovim Configuration
- Symlink neovim configuration by running:
```sh
stow neovim
```
- Launch neovim (Ignore colorscheme load errors that appear).
- Inside neovim, run:
```viml
:PlugInstall
```
to download plugins.
- Restart neovim.

# Zsh Configuration
- Symlink zsh configuration files by running:
```sh
stow zsh
```
- Run zsh and wait for modules to download.

# Emacs configuration
- Copy emacs configuration file by running:
```sh
stow emacs
```
- Run emacs and wait for plugins to download.

