# Dotfiles
My personal dotfiles.

## Setup
Install [GNU Stow](https://www.gnu.org/software/stow/).

- Clone the repo to your machine to home repository.
```sh
git clone https://github.com/nevinvalsaraj/dotfiles.git ~/.dotfiles
```

## Neovim Configuration
- Symlink neovim configuration:
```sh
stow neovim
```
- Run `nvim` (ignore colorscheme load errors that appear).
- Once neovim has launched, run:
```viml
:PlugInstall
```
to download plugins.
- Restart neovim.

## Zsh Configuration
- Symlink zsh configuration files:
```sh
stow zsh
```
- Run `exec zsh` and wait for modules to download.

## Emacs Configuration
- Symlink configuration file:
```sh
stow emacs
```
- Run `emacs` and wait for plugins to download.

## Kitty Terminal Configuration

- Symlink `kitty.conf` file:
``` sh
stow kitty
```

## FD Ignore File Configuration
- Symlink `.fdignore` file:

``` sh
stow fdignore
```
