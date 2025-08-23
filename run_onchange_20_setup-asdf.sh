#!/bin/sh
set -e
set -u

if command -v asdf >/dev/null 2>&1; then
  # Ensure Node.js plugin
  if ! asdf plugin list | grep -q '^nodejs$'; then
    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
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

  # Install latest go
  LATEST_GO="$(asdf latest golang)"
  CURRENT_GO="$(asdf global golang 2>/dev/null || true)"

  if ! asdf list golang | grep -q "$LATEST_GO"; then
    echo "Installing Go $LATEST_GO and setting it global"
    asdf install golang "$LATEST_GO"
    asdf global golang "$LATEST_GO"
  elif [ "$CURRENT_GO" != "$LATEST_GO" ]; then
    echo "Setting Go global to $LATEST_GO"
    asdf global golang "$LATEST_GO"
  fi

  asdf reshim golang
fi

