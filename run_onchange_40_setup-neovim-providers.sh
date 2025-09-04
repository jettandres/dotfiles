#!/bin/sh
set -e
set -u

npm install -g neovim
python3 -m pip install pynvim

# install uv for VectoreCode AI plugin (untested, but needed later)
curl -LsSf https://astral.sh/uv/install.sh | sh
uv tool install "vectorcode<1.0.0"
