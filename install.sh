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


# check OS
OS_NAME=$(uname -s)

case "$OS_NAME" in
    Linux)
        echo "Running on Linux"
        $HOME/dotfiles/install_linux.sh
        ;;
    Darwin)
        echo "Running on macOS"
        echo "Installation for macOS have not been implemented yet" 
        ;;
    FreeBSD|OpenBSD|NetBSD)
        echo "Running on a BSD-based system"
        echo "Installation for BSD-based system have not been implemented yet" 
        ;;
    CYGWIN*|MINGW*|MSYS*)
        echo "Running on Windows (via Cygwin/MinGW/MSYS)"
        $HOME/dotfiles/install_win.sh
        ;;
    *)
        echo "Unknown OS: $OS_NAME"
        ;;
esac
