#!/bin/bash

# Minarchy Menu
# Inspired by https://github.com/basecamp/omarchy

MENU_WIDTH=300
MENU_HEIGHT=400

menu() {
  local prompt="$1"
  local options="$2"
  echo -e "$options" | wofi --dmenu --prompt "$prompt" --width $MENU_WIDTH --cache-file /dev/null
}

notify() {
  notify-send "$1" "$2"
}

# ========== THEME MENU ==========
show_theme_menu() {
  local themes=$(ls /usr/share/themes 2>/dev/null | head -20 | sed 's/^/󰸌  /')
  local choice=$(menu "Theme" "$themes")
  if [[ -n "$choice" ]]; then
    local theme=$(echo "$choice" | sed 's/^󰸌  //')
    gsettings set org.gnome.desktop.interface gtk-theme "$theme" 2>/dev/null
  fi
}

show_icon_theme_menu() {
  local themes=$(ls /usr/share/icons 2>/dev/null | head -20 | sed 's/^/  /')
  local choice=$(menu "Icons" "$themes")
  if [[ -n "$choice" ]]; then
    local theme=$(echo "$choice" | sed 's/^  //')
    gsettings set org.gnome.desktop.interface icon-theme "$theme" 2>/dev/null
  fi
}

show_cursor_theme_menu() {
  local themes=$(ls /usr/share/icons 2>/dev/null | grep -i cursor | head -20 | sed 's/^/󰍽  /')
  local choice=$(menu "Cursor" "$themes")
  if [[ -n "$choice" ]]; then
    local theme=$(echo "$choice" | sed 's/^󰍽  //')
    gsettings set org.gnome.desktop.interface cursor-theme "$theme" 2>/dev/null
  fi
}

# ========== STYLE MENU ==========
show_style_menu() {
  case $(menu "Style" "󰸌  GTK Theme\n󰀻  Icon Theme\n󰍽  Cursor Theme\n󰸉  Wallpaper\n󰖬  Hyprland Config\n󰍜  Waybar Config\n󰖬  Wofi Config") in
  *GTK*) show_theme_menu ;;
  *Icon*) show_icon_theme_menu ;;
  *Cursor*) show_cursor_theme_menu ;;
  *Wallpaper*) show_wallpaper_menu ;;
  *Hyprland*) $TERMINAL -e $EDITOR ~/.config/hypr/hyprland.conf ;;
  *Waybar*) $TERMINAL -e $EDITOR ~/.config/waybar/config.jsonc ;;
  *Wofi*) $TERMINAL -e $EDITOR ~/.config/wofi/style.css ;;
  *) show_main_menu ;;
  esac
}

show_wallpaper_menu() {
  local wp_dir="$HOME/Pictures/wallpapers"
  # Get list of category folders
  local folders=$(find "$wp_dir" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | xargs -n1 basename | sed 's/^/󰉋  /')
  local menu_items="󰒍  Cycle Random (All)\n$folders\n󰥶  Browse Files"

  local choice=$(menu "Wallpaper" "$menu_items")
  case "$choice" in
  *Cycle*)
    local random_wp=$(find "$wp_dir" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" -o -name "*.webp" \) 2>/dev/null | shuf -n 1)
    if [[ -n "$random_wp" ]]; then
      swww img "$random_wp" --transition-type grow --transition-pos center
      notify "Wallpaper" "$(basename "$random_wp")"
    else
      notify "No Wallpapers" "Add images to ~/Pictures/wallpapers/"
    fi
    ;;
  *Browse*)
    local wallpaper=$(zenity --file-selection --title="Select Wallpaper" --file-filter="Images | *.jpg *.jpeg *.png *.gif *.webp" 2>/dev/null)
    if [[ -n "$wallpaper" ]]; then
      swww img "$wallpaper" --transition-type grow --transition-pos center
      notify "Wallpaper Changed" "$(basename "$wallpaper")"
    fi
    ;;
  󰉋\ \ *)
    # Category folder selected - show submenu
    local folder=$(echo "$choice" | sed 's/^󰉋  //')
    show_wallpaper_category "$folder"
    ;;
  *) show_style_menu ;;
  esac
}

show_wallpaper_category() {
  local category="$1"
  local wp_dir="$HOME/Pictures/wallpapers/$category"
  local wallpapers=$(find "$wp_dir" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" -o -name "*.webp" \) 2>/dev/null | xargs -n1 basename | sed 's/^/󰋩  /')
  local menu_items="󰒍  Cycle Random ($category)\n$wallpapers"

  local choice=$(menu "$category" "$menu_items")
  case "$choice" in
  *Cycle*)
    local random_wp=$(find "$wp_dir" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" -o -name "*.webp" \) 2>/dev/null | shuf -n 1)
    if [[ -n "$random_wp" ]]; then
      swww img "$random_wp" --transition-type grow --transition-pos center
      notify "Wallpaper" "$(basename "$random_wp")"
    fi
    ;;
  󰋩\ \ *)
    local file=$(echo "$choice" | sed 's/^󰋩  //')
    swww img "$wp_dir/$file" --transition-type grow --transition-pos center
    notify "Wallpaper" "$file"
    ;;
  *) show_wallpaper_menu ;;
  esac
}

# ========== SETUP MENU ==========
show_setup_menu() {
  case $(menu "Setup" "󰕾  Audio Settings\n󰖩  WiFi\n󰂯  Bluetooth\n󱐋  Power Profile\n󰍹  Display Settings\n󰖬  Hyprland\n󰒲  Hypridle\n󰌾  Hyprlock") in
  *Audio*) pavucontrol & ;;
  *WiFi*) $TERMINAL -e nmtui ;;
  *Bluetooth*) blueman-manager & ;;
  *Power*) show_power_profile_menu ;;
  *Display*) wdisplays & 2>/dev/null || notify "Install wdisplays" "sudo pacman -S wdisplays" ;;
  *Hyprland*) $TERMINAL -e $EDITOR ~/.config/hypr/hyprland.conf ;;
  *Hypridle*) $TERMINAL -e $EDITOR ~/.config/hypr/hypridle.conf ;;
  *Hyprlock*) $TERMINAL -e $EDITOR ~/.config/hypr/hyprlock.conf ;;
  *) show_main_menu ;;
  esac
}

show_power_profile_menu() {
  local profiles="  Performance\n󰗑  Balanced\n󰌪  Power Saver"
  local current=$(powerprofilesctl get 2>/dev/null || echo "unknown")
  local choice=$(menu "Power [$current]" "$profiles")
  if [[ -n "$choice" ]]; then
    local profile=$(echo "$choice" | awk '{print tolower($NF)}')
    [[ "$profile" == "saver" ]] && profile="power-saver"
    powerprofilesctl set "$profile" && notify "Power Profile" "Set to $profile"
  fi
}

# ========== TOGGLE MENU ==========
show_toggle_menu() {
  case $(menu "Toggle" "󰔎  Nightlight (Hyprsunset)\n󱫖  Idle Lock\n󰍜  Waybar\n󰂵  Blur\n󰾆  Animations") in
  *Nightlight*) pkill hyprsunset || hyprsunset -t 4500 & notify "Nightlight" "Toggled" ;;
  *Idle*) pkill hypridle && notify "Idle Lock" "Disabled" || (hypridle & notify "Idle Lock" "Enabled") ;;
  *Waybar*) pkill waybar && notify "Waybar" "Hidden" || (waybar & notify "Waybar" "Shown") ;;
  *Blur*) hyprctl keyword decoration:blur:enabled toggle ;;
  *Animations*) hyprctl keyword animations:enabled toggle ;;
  *) show_main_menu ;;
  esac
}

# ========== CAPTURE MENU ==========
show_capture_menu() {
  case $(menu "Capture" "󰹑  Screenshot (Select)\n󰍹  Screenshot (Full)\n󰻂  Screen Record\n󰃉  Color Picker") in
  *Select*) grim -g "$(slurp)" - | swappy -f - ;;
  *Full*) grim - | wl-copy && notify "Screenshot" "Copied to clipboard" ;;
  *Record*) show_record_menu ;;
  *Color*) hyprpicker -a && notify "Color" "Copied to clipboard" ;;
  *) show_main_menu ;;
  esac
}

show_record_menu() {
  if pgrep wf-recorder > /dev/null; then
    pkill wf-recorder
    notify "Recording" "Stopped"
  else
    local area=$(slurp)
    [[ -n "$area" ]] && wf-recorder -g "$area" -f ~/Videos/recording-$(date +%Y%m%d-%H%M%S).mp4 &
    notify "Recording" "Started - run menu again to stop"
  fi
}

# ========== INSTALL MENU ==========
show_install_menu() {
  case $(menu "Install" "󰣇  Search Pacman\n󰏓  Search AUR\n󰅨  Development Tools\n󰏫  Editors\n󱚤  AI Tools\n󰊗  Gaming\n󰒓  Utilities") in
  *Pacman*) $TERMINAL -e bash -c 'pkg=$(pacman -Slq | fzf --preview "pacman -Si {}" --height=100% --layout=reverse --prompt="Pacman > "); [[ -n "$pkg" ]] && sudo pacman -S "$pkg"; read -p "Press enter..."' ;;
  *AUR*) $TERMINAL -e bash -c 'pkg=$(paru -Slqa 2>/dev/null | fzf --preview "paru -Si {} 2>/dev/null" --height=100% --layout=reverse --prompt="AUR > "); [[ -n "$pkg" ]] && paru -S "$pkg"; read -p "Press enter..."' ;;
  *Development*) show_install_dev_menu ;;
  *Editors*) show_install_editor_menu ;;
  *AI*) show_install_ai_menu ;;
  *Gaming*) show_install_gaming_menu ;;
  *Utilities*) show_install_utils_menu ;;
  *) show_main_menu ;;
  esac
}

show_install_dev_menu() {
  case $(menu "Development" "󰎙  Node.js\n󰌠  Python\n󱘗  Rust\n󰟓  Go\n󰡨  Docker\n󰊢  Git Tools") in
  *Node*) $TERMINAL -e bash -c "sudo pacman -S nodejs npm; read -p 'Done. Press enter...'" ;;
  *Python*) $TERMINAL -e bash -c "sudo pacman -S python python-pip; read -p 'Done. Press enter...'" ;;
  *Rust*) $TERMINAL -e bash -c "sudo pacman -S rustup && rustup default stable; read -p 'Done. Press enter...'" ;;
  *Go*) $TERMINAL -e bash -c "sudo pacman -S go; read -p 'Done. Press enter...'" ;;
  *Docker*) $TERMINAL -e bash -c "sudo pacman -S docker docker-compose && sudo systemctl enable --now docker; read -p 'Done. Press enter...'" ;;
  *Git*) $TERMINAL -e bash -c "sudo pacman -S git lazygit github-cli; read -p 'Done. Press enter...'" ;;
  *) show_install_menu ;;
  esac
}

show_install_editor_menu() {
  case $(menu "Editors" "󰨞  VS Code\n  Neovim\n󰞅  Helix\n󰘦  Zed") in
  *VS*) $TERMINAL -e bash -c "paru -S visual-studio-code-bin; read -p 'Done. Press enter...'" ;;
  *Neovim*) $TERMINAL -e bash -c "sudo pacman -S neovim; read -p 'Done. Press enter...'" ;;
  *Helix*) $TERMINAL -e bash -c "sudo pacman -S helix; read -p 'Done. Press enter...'" ;;
  *Zed*) $TERMINAL -e bash -c "sudo pacman -S zed; read -p 'Done. Press enter...'" ;;
  *) show_install_menu ;;
  esac
}

show_install_ai_menu() {
  case $(menu "AI Tools" "󱚤  Claude Code\n󱚤  Ollama\n󱚤  LM Studio") in
  *Claude*) $TERMINAL -e bash -c "sudo pacman -S claude-code 2>/dev/null || paru -S claude-code; read -p 'Done. Press enter...'" ;;
  *Ollama*) $TERMINAL -e bash -c "sudo pacman -S ollama && sudo systemctl enable --now ollama; read -p 'Done. Press enter...'" ;;
  *LM*) $TERMINAL -e bash -c "paru -S lmstudio; read -p 'Done. Press enter...'" ;;
  *) show_install_menu ;;
  esac
}

show_install_gaming_menu() {
  case $(menu "Gaming" "󰓓  Steam\n󰺵  Lutris\n󰡶  Wine") in
  *Steam*) $TERMINAL -e bash -c "sudo pacman -S steam; read -p 'Done. Press enter...'" ;;
  *Lutris*) $TERMINAL -e bash -c "sudo pacman -S lutris; read -p 'Done. Press enter...'" ;;
  *Wine*) $TERMINAL -e bash -c "sudo pacman -S wine winetricks; read -p 'Done. Press enter...'" ;;
  *) show_install_menu ;;
  esac
}

show_install_utils_menu() {
  case $(menu "Utilities" "  File Manager\n󰋩  Image Viewer\n󰕧  Video Player\n󰈦  PDF Reader") in
  *File*) $TERMINAL -e bash -c "sudo pacman -S nautilus; read -p 'Done. Press enter...'" ;;
  *Image*) $TERMINAL -e bash -c "sudo pacman -S loupe; read -p 'Done. Press enter...'" ;;
  *Video*) $TERMINAL -e bash -c "sudo pacman -S vlc; read -p 'Done. Press enter...'" ;;
  *PDF*) $TERMINAL -e bash -c "sudo pacman -S evince; read -p 'Done. Press enter...'" ;;
  *) show_install_menu ;;
  esac
}

# ========== UPDATE MENU ==========
show_update_menu() {
  case $(menu "Update" "󰏖  System Update\n  Update AUR\n󰑐  Refresh Mirrors\n󰃢  Clear Cache") in
  *System*) $TERMINAL -e bash -c "sudo pacman -Syu; read -p 'Done. Press enter...'" ;;
  *AUR*) $TERMINAL -e bash -c "paru -Syu; read -p 'Done. Press enter...'" ;;
  *Mirrors*) $TERMINAL -e bash -c "sudo cachyos-rate-mirrors; read -p 'Done. Press enter...'" 2>/dev/null || $TERMINAL -e bash -c "sudo pacman -S reflector && sudo reflector --latest 10 --sort rate --save /etc/pacman.d/mirrorlist; read -p 'Done. Press enter...'" ;;
  *Cache*) $TERMINAL -e bash -c "sudo pacman -Sc; read -p 'Done. Press enter...'" ;;
  *) show_main_menu ;;
  esac
}

# ========== SYSTEM MENU ==========
show_system_menu() {
  case $(menu "System" "󰌾  Lock\n󰤄  Suspend\n󰜉  Reboot\n󰐥  Shutdown\n󰗽  Logout") in
  *Lock*) hyprlock ;;
  *Suspend*) systemctl suspend ;;
  *Reboot*) systemctl reboot ;;
  *Shutdown*) systemctl poweroff ;;
  *Logout*) hyprctl dispatch exit ;;
  *) show_main_menu ;;
  esac
}

# ========== LEARN MENU ==========
show_learn_menu() {
  case $(menu "Learn" "󰌌  Keybindings\n󰖬  Hyprland Wiki\n󰣇  Arch Wiki\n󰏖  CachyOS Wiki") in
  *Keybindings*) $TERMINAL -e bash -c "grep -E '^bind' ~/.config/hypr/hyprland.conf | less" ;;
  *Hyprland*) xdg-open "https://wiki.hyprland.org/" ;;
  *Arch*) xdg-open "https://wiki.archlinux.org/" ;;
  *CachyOS*) xdg-open "https://wiki.cachyos.org/" ;;
  *) show_main_menu ;;
  esac
}

# ========== MAIN MENU ==========
show_main_menu() {
  case $(menu "Menu" "󰀻  Apps\n󰧑  Learn\n󰹑  Capture\n󰔎  Toggle\n󰏘  Style\n󰒓  Setup\n󰏖  Install\n󰏗  Update\n󰐥  System") in
  *Apps*) wofi --show drun ;;
  *Learn*) show_learn_menu ;;
  *Capture*) show_capture_menu ;;
  *Toggle*) show_toggle_menu ;;
  *Style*) show_style_menu ;;
  *Setup*) show_setup_menu ;;
  *Install*) show_install_menu ;;
  *Update*) show_update_menu ;;
  *System*) show_system_menu ;;
  esac
}

# Set defaults
TERMINAL=${TERMINAL:-kitty}
EDITOR=${EDITOR:-nvim}

# Handle direct submenu access
if [[ -n "$1" ]]; then
  case "${1,,}" in
    system) show_system_menu ;;
    style) show_style_menu ;;
    setup) show_setup_menu ;;
    install) show_install_menu ;;
    update) show_update_menu ;;
    toggle) show_toggle_menu ;;
    capture) show_capture_menu ;;
    *) show_main_menu ;;
  esac
else
  show_main_menu
fi
