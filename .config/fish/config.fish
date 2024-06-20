if status is-interactive
    # Commands to run in interactive sessions can go here
end

if status is-login
    if test -z "$WAYLAND_DISPLAY" -a "$XDG_VTNR" = 1
       #exec sway
    end
end

# asdf
source /opt/asdf-vm/asdf.fish
source ~/.asdf/plugins/golang/set-env.fish

set -x GOPATH $HOME/go
set -x PATH $PATH $GOPATH/bin

# Enable AWS CLI autocompletion: github.com/aws/aws-cli/issues/1079
complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'
