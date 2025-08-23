#!/bin/sh
set -e
set -u

asdf install nodejs latest
asdf install golang latest

asdf set golang latest
asdf set nodejs latest

asdf reshim golang
asdf reshim nodejs
