# justfile

# Run this once
install-nix:
  sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
  echo "Nix installed. Please restart your shell (or run: just post-restart)"

restart-shell:
  exec "$SHELL" -l

# Run this *after* shell restart
setup: install-nix restart-shell
    nix-shell ./shell.nix
