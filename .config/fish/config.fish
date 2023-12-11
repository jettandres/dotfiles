if status is-interactive
    # Commands to run in interactive sessions can go here
end

if status is-login
    if test -z "$WAYLAND_DISPLAY" -a "$XDG_VTNR" = 1
       #exec sway
    end
end

source /opt/asdf-vm/asdf.fish
