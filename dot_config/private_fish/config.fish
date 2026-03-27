if status is-interactive
    # Commands to run in interactive sessions can go here
    atuin init fish --disable-up-arrow | source
end

set -gx EDITOR nvim

if test -d $HOME/Android/Sdk
  set -gx ANDROID_HOME $HOME/Android/Sdk
  fish_add_path $ANDROID_HOME/emulator
  fish_add_path $ANDROID_HOME/platform-tools
end

if test -d $HOME/android-studio/bin
  fish_add_path $HOME/android-studio/bin
end

# Detect pip executables
fish_add_path $HOME/.local/bin

# opencode
fish_add_path /home/jettandres/.opencode/bin
