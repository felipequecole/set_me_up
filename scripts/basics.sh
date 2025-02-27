#!/bin/bash

echo "Installing git"
$os_installer git

echo "Installing curl"
$os_installer curl

echo "Installing gcc and other build tools"
$os_installer build-essential apt-transport-https ca-certificates curl uidmap dbus-user-session

if ! command -v zsh 2>&1 >/dev/null; then
  echo "Installing zsh"
  $os_installer zsh
  echo "Setting zsh as default shell"
  chsh -s "$(which zsh)"
fi

sh -c "$(curl -fsSL https://raw.githubusercontent.com/loket/oh-my-zsh/feature/batch-mode/tools/install.sh)"

if ! command -v brew 2>&1 >/dev/null; then
  echo "Installing homebrew"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if ! command -v jq 2>&1 >/dev/null; then
  echo "Installing jq"
  brew install -y jq
fi

if ! command -v code 2>&1 >/dev/null; then
  echo "Installing Visual Studio Code"
  sudo apt-get install wget gpg
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
  sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
  echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
  rm -f packages.microsoft.gpg
  sudo apt update
  $os_install code
fi

if ! command -v docker 2>&1 >/dev/null; then
  curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
  sudo sh /tmp/get-docker.sh
fi
