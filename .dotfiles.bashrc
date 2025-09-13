# ls aliases
if ! command -v ll >/dev/null; then
    alias ll='ls -alF'
fi
if ! command -v la >/dev/null; then
    alias la='ls -A'
fi
if ! command -v l >/dev/null; then
    alias l='ls -CF'
fi

# starship
eval "$(starship init bash)"

