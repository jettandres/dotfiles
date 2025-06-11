# justfile

# Run this once
install-nix:
    sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
    echo "Nix installed. Please restart your shell (or run: just post-restart)"

# Run this *after* shell restart
post-restart:
    nix-shell ./nix-shell.nix
