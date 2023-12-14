# !/bin/bash
wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 10%-;
wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2}' | xargs -I {} notify-send -a "wpctl" -c "volume" -t 500 'Volume' '{}';
