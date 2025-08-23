#!/bin/sh
set -e
set -u

asdf install nodejs latest
asdf install golang latest
asdf install lua latest
asdf install java openjdk-17
asdf install python 3.9.1
# TODO: install ruby version specific to mobile app development

asdf set -u golang latest
asdf set -u nodejs latest
asdf set -u lua latest
asdf set -u java openjdk-17
asdf set -u python 3.9.1

asdf reshim golang
asdf reshim nodejs
asdf reshim lua
asdf reshim ruby
asdf reshim java
asdf reshim python
