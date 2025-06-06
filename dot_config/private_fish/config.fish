if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -gx EDITOR nvim

# set -gx JAVA_HOME /usr/lib/jvm/java-17-openjdk-17.0.9.0.9-3.fc39.x86_64
fish_add_path $JAVA_HOME/bin:$PATH

set -gx ANDROID_HOME $HOME/Android/Sdk
fish_add_path $ANDROID_HOME/emulator
fish_add_path $ANDROID_HOME/platform-tools
fish_add_path (go env GOPATH)/bin
fish_add_path $HOME/android-studio/bin

# Detect pip executables
fish_add_path $HOME/.local/bin

# Enable AWS CLI autocompletion: github.com/aws/aws-cli/issues/1079
complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'
source ~/.asdf/asdf.fish

# Golang setup
source ~/.asdf/plugins/golang/set-env.fish

# asdf java
. ~/.asdf/plugins/java/set-java-home.fish
