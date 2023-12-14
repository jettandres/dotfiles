# !/bin/bash

system_clock=$(date +'  %Y-%m-%d |   %I:%M %p')
cpu_temp=$(sensors | grep CPU | awk '{print $2}')
mem_usage=$(free | grep Mem | awk '{printf("%.2f\n",$3/$2 * 100.0)}')
battery=$(~/.config/sway/scripts/battery.sh)

echo "  cpu: $cpu_temp |   mem: $mem_usage% | $battery | $system_clock"
