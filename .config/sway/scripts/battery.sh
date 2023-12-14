# !/bin/bash

battery_level=$(cat /sys/class/power_supply/BAT0/capacity)

# Thanks ChatGPT
# Define an array of battery icons mapped to ranges.
battery_discharge_icons=(
    '󰁺'
    '󰁻'
    '󰁼'
    '󰁽'
    '󰁾'
    '󰁿'
    '󰂀'
    '󰂁'
    '󰂂'
    '󰁹'
)

battery_charge_icons=(
    '󰢜 '
    '󰂆 '
    '󰂇 '
    '󰂈 '
    '󰢝 '
    '󰂉 '
    '󰢞 '
    '󰂊 '
    '󰂋 '
    '󰂅 '
)

# Calculate the index for the battery_icons array based on battery level
icon_index=$((battery_level / 10))

# Set the battery_icon based on the calculated index
battery_discharge_icon="${battery_discharge_icons[$icon_index]}"
battery_charge_icon="${battery_charge_icons[$icon_index]}"

# optional. fluctating bec of tlp? still wip
# mins_remaining="$(acpi -b | awk '{print $5}')"

battery_status=$(cat /sys/class/power_supply/BAT0/status)

battery_icon='n/a'

if [ $battery_status = "Discharging" ]; then
  battery_icon=$(printf '%s' $battery_discharge_icon)
elif [ $battery_status = "Charging" ]; then
  battery_icon=$(printf '%s.' $battery_charge_icon)
fi

formatted_battery=$(printf '%s battery: %s%%' $battery_icon $battery_level)

echo $formatted_battery
