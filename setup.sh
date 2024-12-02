#!/bin/bash

# Variables
THEME="'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/quick-term.omp.json'"  # Replace with your desired theme
FONT="Meslo"  # Replace with your desired font

# Function to install Oh My Posh
install_oh_my_posh() {
  echo "Installing Oh My Posh..."
  curl -s https://ohmyposh.dev/install.sh | bash -s
}

# Function to install the specified font
install_font() {
  echo "Installing font: $FONT..."
  oh-my-posh font install "$FONT"
}

# Function to configure the shell
configure_shell() {
  local shell_config=$1
  local shell_type=$2
  
  echo "Configuring $shell_config with Oh My Posh..."

  # Check if oh-my-posh is already configured
  if grep -q "oh-my-posh init" "$shell_config"; then
    echo "Oh My Posh already configured. Updating the theme..."
    sed -i.bak "/oh-my-posh init/ s|--config .*|--config $THEME)\"|" "$shell_config"
  else
    echo "Adding Oh My Posh initialization to $shell_config..."
    echo "eval \"\$(oh-my-posh init $shell_type --config $THEME)\"" >> "$shell_config"
  fi
}

# Detect OS
OS=$(uname -s)
case "$OS" in
  Linux)
    echo "Detected Linux."
    SHELL_CONFIG="$HOME/.bashrc"
    SHELL_TYPE="bash"
    ;;

  Darwin)
    echo "Detected macOS."
    SHELL_CONFIG="$HOME/.zshrc"
    SHELL_TYPE="zsh"
    ;;

  CYGWIN*|MINGW32*|MSYS*|MINGW*)
    echo "Detected Windows."
    SHELL_CONFIG="$HOME/.bashrc"
    SHELL_TYPE="bash"
    ;;

  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

install_oh_my_posh
install_font
configure_shell "$SHELL_CONFIG" "$SHELL_TYPE"

# Reload the shell config
echo "Reloading shell configuration..."
if [[ "$SHELL_TYPE" == "bash" ]]; then
  source "$SHELL_CONFIG"
elif [[ "$SHELL_TYPE" == "zsh" ]]; then
  exec zsh
fi

echo "Oh My Posh installation and configuration completed!"
