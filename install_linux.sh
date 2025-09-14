#!/bin/bash -ue

echo "Start installation for Linux"

echo "Check configs and make symbolic links"
# .bashrc
if [ -e ~/.bashrc ]; then
    echo "~/.bashrc already exists"
else
    echo "~/.bashrc does not exist and try to copy from /etc/skel/.bashrc"
    if [ -e /etc/skel/.bashrc ]; then
        cp /etc/skel/.bashrc ~/
    else
        ln -snvf ~/dotfiles/.bashrc ~/
    fi
fi
if ! grep -q ". ~/dotfiles/.dotfiles.bashrc" ~/.bashrc; then
    echo '. ~/dotfiles/.dotfiles.bashrc' >> ~/.bashrc
fi

# .profile
if [ -e ~/.profile ]; then
    echo "~/.profile already exists"
else
    echo "~/.profile does not exist and try to copy from /etc/skel/.profile"
    if [ -e /etc/skel/.profile ]; then
        cp -v /etc/skel/.profile ~/
    fi
fi

mkdir -p ~/.config
ln -snvf ~/dotfiles/.vimrc ~/
ln -snvf ~/dotfiles/.tmux.conf ~/

# starship
ln -snvf ~/dotfiles/.config/starship.toml ~/.config/starship.toml

# # ranger
# mkdir -p ~/.config/ranger
# ln -snvf ~/dotfiles/.config/ranger/rc.conf ~/.config/ranger/rc.conf


echo "Install dependencies"

mkdir -p ~/.local/bin
# set PATH
if [ -e ~/.profile ]; then
    if ! grep -q 'PATH="$HOME/.local/bin:$PATH"' ~/.profile; then
        echo 'PATH="$HOME/.local/bin:$PATH"' >> ~/.profile
    fi
    . "$HOME/.profile"
else
    echo "~/.profile does not exist"
    echo "Please set PATH to $HOME/.local/bin manually"
    echo '    PATH="$HOME/.local/bin:$PATH"'
fi

# install brew
set +e
if ! command -v brew > /dev/null; then
    echo "installing brew ..."
    git clone https://github.com/Homebrew/brew ~/.local/homebrew
    eval "$(~/.local/homebrew/bin/brew shellenv)"
    brew update --force --quiet
    ln -snvf ~/.local/Homebrew/bin/brew ~/.local/bin
else
    echo "brew installed"
fi
set -e

# install unzip
if ! command -v unzip > /dev/null; then
    brew install unzip
else
    echo "unzip installed"
fi

# # update tmux to enable yazi image preview
# if command -v brew > /dev/null; then
#     echo "updating tmux ..."
#     brew update
#     brew install tmux
# fi

# # install cargo
# if ! command -v cargo > /dev/null; then
#     echo "installing cargo ..."
#     curl https://sh.rustup.rs -sSf | sh -s -- -y
#     . "$HOME/.cargo/env"
# else
#     echo "cargo installed"
#     . "$HOME/.cargo/env"
# fi

# install starship
if ! command -v starship > /dev/null; then
    echo "installing starship ..."
    # cargo install --locked starship
    sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -y --bin-dir $HOME/.local/bin
else
    echo "starship installed"
fi

# install pueue
if ! command -v pueue > /dev/null; then
    echo "installing pueue ..."
    # cargo install --locked pueue
    curl -fsSL -o ~/.local/bin/pueue https://github.com/Nukesor/pueue/releases/latest/download/pueue-x86_64-unknown-linux-musl
    curl -fsSL -o ~/.local/bin/pueued https://github.com/Nukesor/pueue/releases/latest/download/pueued-x86_64-unknown-linux-musl
    chmod u+x ~/.local/bin/pueue*
else
    echo "pueue installed"
fi

# install yazi
if ! command -v yazi > /dev/null; then
    echo "installing yazi ..."
    # cargo install --force yazi-build
    curl -fsSL -o ~/.local/yazi.zip https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-musl.zip
    unzip -q ~/.local/yazi.zip -d ~/.local/yazi
    ln -snvf ~/.local/yazi/*/ya ~/.local/bin
    ln -snvf ~/.local/yazi/*/yazi ~/.local/bin
else
    echo "yazi installed"
fi

# # install ranger
# if ! command -v ranger > /dev/null; then
#     echo "installing ranger ..."
#     pip install --user ranger-fm
# else
#     echo "ranger installed"
# fi
