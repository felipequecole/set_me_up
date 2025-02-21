#!/bin/bash

# Python related

echo "Installing python"
$os_installer python3

echo "Installing pip"
$os_installer python3-pip

echo "Installing pipx"
$os_installer pipx
pipx ensurepath

echo "Installing virtualenv"
pipx install virtualenv

echo "Installing poetry"
pipx install poetry

# Java related

echo "Installing Java"
$os_installer openjdk-21-jdk

if ! command -v mvn 2>&1 >/dev/null; then
  echo "Installing Maven"
  $os_installer maven
fi

# Golang related

if [ ! -d "/usr/local/go" ] ; then
  echo "Installing Golang"
  wget https://go.dev/dl/go1.24.0.linux-amd64.tar.gz -O /tmp/go1.24.0.linux-amd64.tar.gz
  sudo tar -C /usr/local -xzf /tmp/go1.24.0.linux-amd64.tar.gz
  rm -f /tmp/go1.24.0.linux-amd64.tar.gz
  echo "export PATH=$PATH:/usr/local/go/bin" >> $HOME/.zshrc
fi

# Node/Javascript related (sorry 😢)
echo "Installing Node Version Manager"
PROFILE=$HOME/.zshrc
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash


# Rust Related
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
