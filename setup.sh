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
  echo "Configuring $SHELL_CONFIG with Oh My Posh..."

  # Check if oh-my-posh is already configured
  if grep -q "oh-my-posh init" "$SHELL_CONFIG"; then
    echo "Oh My Posh already configured. Updating the theme..."
    sed -i.bak "/oh-my-posh init/ s|--config .*|--config $THEME)\"|" "$SHELL_CONFIG"
  else
    echo "Adding Oh My Posh initialization to $SHELL_CONFIG..."
    echo "eval \"\$(oh-my-posh init $SHELL_TYPE --config $THEME)\"" >> "$SHELL_CONFIG"
  fi
}

# Reload the shell config
reload_shell() {
  echo "Reloading shell configuration..."
  if [[ "$SHELL_TYPE" == "bash" ]]; then
    source "$SHELL_CONFIG"
  elif [[ "$SHELL_TYPE" == "zsh" ]]; then
    exec zsh
  fi
}

# Sort out the path
check_path() {
  if ! hash oh-my-posh &> /dev/null; then
    echo "oh-my-posh not found on path, attempting to add..."
    case "$OS" in
      Linux)
        echo "export PATH=$PATH:$HOME/.local/bin" >> $SHELL_CONFIG
        ;;
      Darwin)
        echo "export PATH=$PATH:/opt/homebrew/bin" >> $SHELL_CONFIG
        ;;
      *)
        echo "Unsupported OS: $OS"
        exit 1
        ;;
    esac
  fi
  
  reload_shell
  if ! hash oh-my-posh &> /dev/null; then
    echo "Path is borked, still can't find oh-my-posh! Exiting"
    exit 1
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
  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

install_oh_my_posh
check_path
install_font
configure_shell

reload_shell

echo "Oh My Posh installation and configuration completed!"
