#!/usr/bin/env bash

# install nix-shell
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
nix-shell ./nix-shell.nix
chezmoi init --source .
