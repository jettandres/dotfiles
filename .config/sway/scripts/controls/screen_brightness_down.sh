# !/bin/bash
xbacklight -dec 10;
notify-send -a "xbacklight" -c "system" -t 3000 "Brightness" "$(xbacklight -get)";
