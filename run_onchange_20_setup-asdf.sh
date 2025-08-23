#!/bin/sh
set -eu

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
  GO_DIR="$(asdf where golang 2>/dev/null || true)"
  if [ -n "$GO_DIR" ] && [ -f "$GO_DIR/go/bin/go" ]; then
    fish -c '
      set -q ASDF_DATA_DIR; or set ASDF_DATA_DIR "$HOME/.asdf"
      source "$ASDF_DATA_DIR/plugins/golang/set-env.fish"
    '
  fi

  # Install latest Go if plugin available
  if asdf plugin list | grep -q '^golang$'; then
    LATEST_GO="$(asdf latest golang)"
    CURRENT_GO="$(asdf global golang 2>/dev/null | awk "{print \$1}" || true)"

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
fi

