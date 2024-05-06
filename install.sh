#!/bin/bash

set -ue

# install dependencies
sudo apt-get install -y \
  wget \
  curl \
  vim \
  tmux

# install starship
curl -sS https://starship.rs/install.sh | sh
if ! grep - q 'eval "$(starship init bash)"' ~/.bashrc; then
  echo 'eval "$(starship init bash)"' >> ~/.bashrc
fi

# symbolic link
ln -snf ~/dotfiles/.vimrc ~/
ln -snf ~/dotfiles/.tmux.conf ~/

