#!/usr/bin/env bash

cat banner.txt

echo "Installing ..."

DOTFILES_DIR=$(pwd)

ln -s ${DOTFILES_DIR}/zsh/zprofile ${HOME}/.zprofile
ln -s ${DOTFILES_DIR}/zsh/zshrc ${HOME}/.zshrc
ln -s ${DOTFILES_DIR}/zsh/zshenv ${HOME}/.zshenv
ln -s ${DOTFILES_DIR}/zsh/zsh_plugins.txt ${HOME}/.zsh_plugins.txt
