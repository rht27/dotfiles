#!/bin/bash -ue

DOT_DIR="$HOME/dotfiles"

if [ ! -d ${DOT_DIR} ]; then
    if command -v git > /dev/null; then
        git clone https://github.com/rht27/dotfiles.git ${DOT_DIR}
    else
        echo "git required"
        exit 1
    fi
fi


# check required dependencies
if ! command -v curl > /dev/null; then
    echo "curl required"
    exit 1
fi


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
    echo -e '# User settings \n. ~/dotfiles/.dotfiles.bashrc\n' >> ~/.bashrc
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

ln -snvf ~/dotfiles/.vimrc ~/
ln -snvf ~/dotfiles/.tmux.conf ~/

# starship
ln -snvf ~/dotfiles/.config/starship.toml ~/.config/starship.toml

# ranger
mkdir -p ~/.config/ranger
ln -snvf ~/dotfiles/.config/ranger/rc.conf ~/.config/ranger/rc.conf


echo "Install dependencies"
# install starship
if ! command -v starship > /dev/null; then
    echo "installing starship ..."
    curl -fsSL https://starship.rs/install.sh | sh
else
    echo "starship installed"
fi

# install pueue
if ! command -v pueue > /dev/null; then
    echo "installing pueue ..."
    curl -fsSL -o ~/.local/bin/pueue https://github.com/Nukesor/pueue/releases/download/v3.4.1/pueue-linux-x86_64
    curl -fsSL -o ~/.local/bin/pueued https://github.com/Nukesor/pueue/releases/download/v3.4.1/pueued-linux-x86_64
    chmod u+x ~/.local/bin/pueue*
else
    echo "pueue installed"
fi

# install ranger
if ! command -v ranger > /dev/null; then
    echo "installing ranger ..."
    pip install ranger-fm
else
    echo "ranger installed"
fi

