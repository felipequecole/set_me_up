#!/bin/bash

echo "Installing Neovim"

if ! command -v nvim 2>&1 >/dev/null; then
  brew install neovim
fi

if [ ! -f "$HOME/.config/nvim/lazy-lock.json" ]; then
  echo "Installing LazyVim"

  mv ~/.config/nvim{,.bak}
  mv ~/.local/share/nvim{,.bak}
  mv ~/.local/state/nvim{,.bak}
  mv ~/.cache/nvim{,.bak}

  git clone https://github.com/LazyVim/starter ~/.config/nvim
  rm -rf ~/.config/nvim/.git
fi

if ! command -v tmux 2>&1 >/dev/null; then
  echo "Installing tmux"
  brew install tmux
fi

if [ ! -f "$HOME/.tmux.conf" ]; then
  echo "Installing tmux plugin manager"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  cp ./dotfiles/.tmux.conf $HOME/.tmux.conf
fi

if [ ! -d "$HOME/tools/entr" ]; then
  echo "Installing entr"
  git clone https://github.com/eradman/entr.git $HOME/tools/entr
  cd $HOME/tools/entr
  ./configure
  make test
  sudo make install
  cd -
fi

if ! command -v fzf 2>&1 >/dev/null; then
  echo "Installing fzf"
  brew install fzf
fi

echo "Installing starship"
curl -sS https://starship.rs/install.sh | sh

echo "Install mcfly"
brew install mcfly

echo "Install zoxide"
brew install zoxide

if ! command -v bat 2>&1 >/dev/null; then
  echo "Installing bat"
  brew install bat
fi

if ! command -v aws 2>&1 >/dev/null; then
  echo "Installing awscli"
  brew install awscli
fi

echo "Copy over zsh dotfile if not already installed"
if [ ! -f "$HOME/.zshrc" ]; then
  installed=$(cat $HOME/.zshrc | grep DO_NOT_REMOVE_INSTALLED_MARKER)
  if [ -z "$installed" ]; then
    cp ./dotfiles/.zshrc $HOME/.zshrc
  fi
fi

echo "Copy over tmux conf if not already installed"
if [ ! -f "$HOME/.tmux.conf" ]; then
  installed=$(cat $HOME/.tmux.conf | grep DO_NOT_REMOVE_INSTALLED_MARKER)
  if [ -z "$installed" ]; then
    cp ./dotfiles/.tmux.conf $HOME/.tmux.conf
  fi
fi


