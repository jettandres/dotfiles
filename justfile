# justfile

setup-arch:
  # use pacman to install desktop packages
  sudo pacman -Syu;
  sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

setup-osx:
  # use homebrew

