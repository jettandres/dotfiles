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

  # Ensure Lua plugin
  if ! asdf plugin list | grep -q '^lua$'; then
    asdf plugin add lua https://github.com/Stratus3D/asdf-lua.git
  fi

  # Ensure Ruby plugin
  if ! asdf plugin list | grep -q '^ruby$'; then
    asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
  fi

  # Ensure Python plugin
  if ! asdf plugin list | grep -q '^python$'; then
    asdf plugin add python https://github.com/asdf-community/asdf-python.git
  fi

  # Ensure Java plugin
  if ! asdf plugin list | grep -q '^java$'; then
    asdf plugin add java https://github.com/halcyon/asdf-java.git
  fi
  
  # Source Go env script for Fish (only if installed)
  if fish -c "test -f (asdf where golang 2>/dev/null)/go/bin/go" 2>/dev/null; then
    fish -c 'set -q ASDF_DATA_DIR; or set ASDF_DATA_DIR "$HOME/.asdf";
             source "$ASDF_DATA_DIR/plugins/golang/set-env.fish"'
  fi

  # Add other plugins here
fi

