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
  chsh -s $(which zsh)
fi

sh -c "$(curl -fsSL https://raw.githubusercontent.com/loket/oh-my-zsh/feature/batch-mode/tools/install.sh)"


if ! command -v brew 2>&1 >/dev/null; then
  echo "Installing homebrew"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo >> $HOME/.bashrc
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.zshrc
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.bashrc
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  source $HOME/.bashrc
fi


if ! command -v jq 2>&1 >/dev/null; then
  echo "Installing jq"
  brew install -y jq
fi

if ! command -v code 2>&1 >/dev/null; then
  echo "Installing Visual Studio Code"
  sudo apt-get install wget gpg
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
  echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
  rm -f packages.microsoft.gpg
  sudo apt update
  $os_install code
fi

if ! command -v docker 2>&1 >/dev/null; then
  if [[ $(lsb_release -is 2>/dev/null) == "Ubuntu" ]]; then
     echo "Installing Docker"
      # Add Docker's official GPG key:
      $os_package_update
      sudo install -m 0755 -d /etc/apt/keyrings
      sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
      sudo chmod a+r /etc/apt/keyrings/docker.asc

      # Add the repository to Apt sources:
      echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
      $os_package_update
      $os_installer docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras
      sudo groupadd docker
      sudo usermod -aG docker $USER
      sudo systemctl enable docker.service
      sudo systemctl start containerd.service
      echo "YOU WILL NEED TO LOGOUT AND LOGIN AGAIN TO USE DOCKER WITHOUT ROOT!"
  else
      echo "This script is not running on Ubuntu. You will need to install Docker manually."
  fi
 fi

