#!/usr/bin/env bash

if [ -z "$NIX_ENV_READY" ]; then
  echo "Installing Nix..."
  sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon

  echo "Restarting shell..."
  # Set a flag so we know we've already installed Nix next time
  exec env NIX_ENV_READY=1 "$SHELL" -l
else
  echo "Shell restarted. Running nix-shell..."
  nix-shell ./nix-shell.nix
fi
