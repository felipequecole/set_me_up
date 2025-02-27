#!/bin/bash

# Change your configs here
export os_installer="sudo apt install -y"
export os_package_update="sudo apt update"
export dotfiles_repo= "git@github.com:felipequecole/dotfiles.git"

set -x
set -e

echo "Starting environment setup"
$os_package_update

./scripts/basics.sh
./scripts/tools.sh
./scripts/languages.sh

unset os_installer
unset os_package_update
unset dotfiles_repo

echo "Environment setup complete"
set +x
