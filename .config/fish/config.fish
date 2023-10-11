if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -gx EDITOR nvim

set -gx ANDROID_HOME $HOME/Android/Sdk
fish_add_path $ANDROID_HOME/emulator
fish_add_path $ANDROID_HOME/platform-tools

source ~/.asdf/asdf.fish
