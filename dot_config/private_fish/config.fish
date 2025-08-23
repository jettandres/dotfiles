if status is-interactive
    # Commands to run in interactive sessions can go here
end

# ASDF configuration code
if test -z $ASDF_DATA_DIR
    set _asdf_shims "$HOME/.asdf/shims"
else
    set _asdf_shims "$ASDF_DATA_DIR/shims"
end

# Do not use fish_add_path (added in Fish 3.2) because it
# potentially changes the order of items in PATH
if not contains $_asdf_shims $PATH
    set -gx --prepend PATH $_asdf_shims
end
set --erase _asdf_shims

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

# Set Golang
source ~/.asdf/plugins/golang/set-env.fish

# Set JAVA_HOME
. ~/.asdf/plugins/java/set-java-home.fish
