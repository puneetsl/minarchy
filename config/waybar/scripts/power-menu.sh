#!/bin/bash
# Power menu using wofi

options="󰌾 Lock\n󰤄 Sleep\n󰍃 Logout\n󰜉 Reboot\n󰐥 Shutdown"

chosen=$(echo -e "$options" | wofi --dmenu --prompt "Power" --width 200 --height 250 --cache-file /dev/null)

case "$chosen" in
    "󰌾 Lock")
        hyprlock
        ;;
    "󰤄 Sleep")
        systemctl suspend
        ;;
    "󰍃 Logout")
        hyprctl dispatch exit
        ;;
    "󰜉 Reboot")
        systemctl reboot
        ;;
    "󰐥 Shutdown")
        systemctl poweroff
        ;;
esac
