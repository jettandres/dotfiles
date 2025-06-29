# Dotfiles
This repository contains my dotfiles and replicable dev environment setup across different machines using Nix and Chezmoi. Always a work-in-progress

# Prerequisites
- [just](https://github.com/casey/just)
    - for bootstrapping initial apps per OS
- [nix-shell](https://github.com/NixOS/nix-shell)
    - for centralizing dev environment
- [chezmoi](https://github.com/twpayne/chezmoi)
    - for syncing configs

# Setup in New Machine
1. Install the prerequisites manually
2. Clone this repository

## Development
- Run nix anywhere and reference the config in this repo with `nix-shell ./nix-shell.nix`
