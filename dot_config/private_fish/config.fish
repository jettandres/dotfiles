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

# Go binaries
fish_add_path $HOME/go/bin

# opencode
if test -d /home/jettandres
  fish_add_path /home/jettandres/.opencode/bin
else if test -d /home/jett
  fish_add_path /home/jett/.opencode/bin
end

# opencode
fish_add_path /home/jett/.opencode/bin
function opencode
  set -lx AWS_REGION "ap-south-1"
  command opencode $argv
end
