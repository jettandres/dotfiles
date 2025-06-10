let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.05";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

pkgs.mkShellNoCC {
  packages = with pkgs; [
    # TODO: remove test packages 
    cowsay
    lolcat

    # Essentials
    git
    fish
    neovim
    asdf
    tmux
    chezmoi
    just
  ];

  # TODO: SECURE ENV
  GREETING = "Hello, Jett!";

  shellHook = ''
    echo $GREETING | cowsay | lolcat
    # Only exec fish if not already inside fish
    if [ -z "$IN_NIX_SHELL_FISH" ]; then
      export IN_NIX_SHELL_FISH=1
      exec fish
    fi
  '';
}
