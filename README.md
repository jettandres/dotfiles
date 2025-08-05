# Dotfiles
This repository contains my dotfiles and replicable dev environment setup across different machines using Nix and Chezmoi. Always a work-in-progress.

# Prerequisites
- [nix-shell](https://github.com/NixOS/nix-shell)
    - for centralizing dev environment
- [chezmoi](https://github.com/twpayne/chezmoi)
    - for syncing configs
- [git] (https://git-scm.com/)
- [gh-cli] (https://cli.github.com/)

# Setup in New Machine
1. Install the prerequisites manually
2. Clone this public repository using https method

# Setup with Chezmoi only
1. Install [chezmoi](chezmoi.io)
2. Run `chezmoi init --apply --verbose https://github.com/jettandres/dotfiles.git`

# Setup with Nix only
- Run nix anywhere and reference the config in this repo with `nix-shell ./nix-shell.nix`
