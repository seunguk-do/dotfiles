export SHELL=`which zsh`
[ -f "$SHELL" ] && exec "$SHELL" -l

. "$HOME/.local/bin/env"
