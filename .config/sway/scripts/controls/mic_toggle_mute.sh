# !/bin/bash
wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

muted=$(wpctl status | grep -I '48' | grep -o 'MUTED')
toggle_status=''

if [ $muted = 'MUTED' ]; then
    toggle_status='MUTED'
  else
    toggle_status='ON'
fi

notify-send -a "wpctl" -c "volume" -t 500 'Mic Toggle' $toggle_status;
