# !/bin/bash
xbacklight -inc 10;
notify-send -a "xbacklight" -c "system" -t 3000 "Brightness" "$(xbacklight -get)";

