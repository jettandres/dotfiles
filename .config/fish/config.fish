if status is-interactive
    # Commands to run in interactive sessions can go here
end

# brew
eval "$(/opt/homebrew/bin/brew shellenv)"

set -gx EDITOR nvim

# Ensure asdf shims are at the front of PATH
set -U fish_user_paths /Users/jett/.asdf/shims $fish_user_paths

fish_add_path $JAVA_HOME/bin:$PATH

set -gx ANDROID_HOME $HOME/Library/Android/sdk
set -gx ANDROID_SDK_ROOT $ANDROID_HOME

fish_add_path $ANDROID_HOME/platform-tools
fish_add_path $ANDROID_HOME/emulator
# fish_add_path (go env GOPATH)/bin

# Enable AWS CLI autocompletion: github.com/aws/aws-cli/issues/1079
complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'

# Golang setup
source ~/.asdf/plugins/golang/set-env.fish

# asdf java
. ~/.asdf/plugins/java/set-java-home.fish

source ~/.asdf/asdf.fish
