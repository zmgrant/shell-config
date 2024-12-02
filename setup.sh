#!/bin/bash

curl -s https://ohmyposh.dev/install.sh | bash -s
oh-my-posh font install meslo
echo "eval "$(oh-my-posh init bash --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/quick-term.omp.json')"" >> ~/.bashrc
exec bash
