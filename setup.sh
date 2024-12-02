#!/bin/bash

theme='https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/quick-term.omp.json'

if [ "$(uname)" == "Darwin" ]; then
  echo "Installing on MacOS"
  brew install jandedobbeleer/oh-my-posh/oh-my-posh
  shell_conf_file=~/.zshrc
  shell_type=zsh
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  echo "installing on Linux"
  curl -s https://ohmyposh.dev/install.sh | bash -s
  shell_conf_file=~/.bashrc
  shell_type=bash
fi
  
oh-my-posh font install meslo
echo "eval "$(oh-my-posh init $shell_type --config $theme)"" >> $shell_conf_file
exec $shell_type
