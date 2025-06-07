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
    fish
    git
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
    fish
  '';
}
