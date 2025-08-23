#!/bin/sh
set -e
set -u

if command -v asdf >/dev/null 2>&1; then
  # Ensure Node.js plugin
  if ! asdf plugin list | grep -q '^nodejs$'; then
    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
    asdf install nodejs latest
    asdf set nodejs latest
  fi

  # Ensure Go plugin
  if ! asdf plugin list | grep -q '^golang$'; then
    asdf plugin add golang https://github.com/asdf-community/asdf-golang.git
  fi

  # Source Go env script for Fish (only if installed)
  if fish -c "test -f (asdf where golang 2>/dev/null)/go/bin/go" 2>/dev/null; then
    fish -c 'set -q ASDF_DATA_DIR; or set ASDF_DATA_DIR "$HOME/.asdf";
             source "$ASDF_DATA_DIR/plugins/golang/set-env.fish"'
  fi

  # Add other plugins here

  asdf reshim nodejs
  asdf reshm golang
fi

