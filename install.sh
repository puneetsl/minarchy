#!/bin/bash

# Minarchy - Minimal Hyprland Setup
# Inspired by Omarchy (https://github.com/basecamp/omarchy)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/config"

echo "╔══════════════════════════════════════╗"
echo "║       Minarchy Installer             ║"
echo "║   Minimal Hyprland Configuration     ║"
echo "╚══════════════════════════════════════╝"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check if running on Arch-based system
if ! command -v pacman &> /dev/null; then
    error "This script requires an Arch-based distribution (pacman not found)"
    exit 1
fi

# Detect AUR helper
AUR_HELPER=""
if command -v paru &> /dev/null; then
    AUR_HELPER="paru"
elif command -v yay &> /dev/null; then
    AUR_HELPER="yay"
fi

install_packages() {
    info "Installing required packages..."

    # Core Hyprland packages
    PACKAGES=(
        hyprland
        hyprlock
        hypridle
        xdg-desktop-portal-hyprland

        # Bar and notifications
        waybar
        mako

        # Launcher and menus
        wofi
        wlogout

        # Wallpaper
        swww

        # Terminal and utilities
        kitty
        nautilus
        btop

        # Clipboard
        wl-clipboard
        cliphist

        # Screenshots
        grim
        slurp
        swappy

        # Screen recording
        wf-recorder

        # Color picker
        hyprpicker

        # Audio
        pavucontrol
        playerctl

        # Brightness
        brightnessctl

        # Network
        network-manager-applet

        # Bluetooth
        blueman

        # File picker
        zenity

        # Fonts
        ttf-jetbrains-mono-nerd

        # Polkit
        polkit-gnome

        # Utils
        fzf
        jq
    )

    sudo pacman -S --needed --noconfirm "${PACKAGES[@]}" || true

    # AUR packages (optional)
    if [[ -n "$AUR_HELPER" ]]; then
        info "Installing AUR packages with $AUR_HELPER..."
        $AUR_HELPER -S --needed --noconfirm google-chrome-stable 2>/dev/null || true
    fi
}

backup_configs() {
    info "Backing up existing configs..."
    local backup_dir="$HOME/.config/minarchy-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$backup_dir"

    for dir in hypr waybar wofi mako; do
        if [[ -d "$HOME/.config/$dir" ]]; then
            cp -r "$HOME/.config/$dir" "$backup_dir/"
            info "Backed up $dir to $backup_dir"
        fi
    done
}

install_configs() {
    info "Installing Minarchy configs..."

    # Create config directories
    mkdir -p ~/.config/{hypr,waybar/scripts,wofi/scripts,mako}

    # Copy configs
    cp -r "$CONFIG_DIR/hypr/"* ~/.config/hypr/
    cp -r "$CONFIG_DIR/waybar/"* ~/.config/waybar/
    cp -r "$CONFIG_DIR/wofi/"* ~/.config/wofi/
    cp -r "$CONFIG_DIR/mako/"* ~/.config/mako/ 2>/dev/null || true

    # Make scripts executable
    chmod +x ~/.config/wofi/scripts/*.sh 2>/dev/null || true
    chmod +x ~/.config/waybar/scripts/*.sh 2>/dev/null || true

    info "Configs installed successfully!"
}

setup_wallpapers() {
    info "Setting up wallpaper directories..."
    mkdir -p ~/Pictures/wallpapers/{Tokyo,Cyberpunk,Nature,Abstract}

    if [[ -d "$SCRIPT_DIR/wallpapers" ]] && [[ "$(ls -A $SCRIPT_DIR/wallpapers 2>/dev/null)" ]]; then
        cp -r "$SCRIPT_DIR/wallpapers/"* ~/Pictures/wallpapers/
        info "Wallpapers copied!"
    else
        warn "No wallpapers in repo. Add your own to ~/Pictures/wallpapers/"
    fi
}

print_keybindings() {
    echo ""
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    Key Bindings                              ║"
    echo "╠══════════════════════════════════════════════════════════════╣"
    echo "║  Super + Return        Terminal (kitty)                      ║"
    echo "║  Super + Space         App Launcher (wofi)                   ║"
    echo "║  Super + Alt + Space   Omarchy Menu                          ║"
    echo "║  Super + W             Close Window                          ║"
    echo "║  Super + F             Fullscreen                            ║"
    echo "║  Super + T             Toggle Floating                       ║"
    echo "║  Super + 1-0           Switch Workspace                      ║"
    echo "║  Super + Shift + 1-0   Move to Workspace                     ║"
    echo "║  Super + Shift + B     Browser (Chrome)                      ║"
    echo "║  Super + Shift + F     File Manager (Nautilus)               ║"
    echo "║  Super + Escape        Power Menu (wlogout)                  ║"
    echo "║  Print                 Screenshot (select area)              ║"
    echo "║  Super + C/V/X         Copy/Paste/Cut (universal)            ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo ""
}

# Main
main() {
    echo "This will install Minarchy Hyprland configuration."
    echo ""
    read -p "Continue? [y/N] " -n 1 -r
    echo ""

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 0
    fi

    install_packages
    backup_configs
    install_configs
    setup_wallpapers

    echo ""
    info "Installation complete!"
    info "Log out and select Hyprland from your display manager."
    print_keybindings
}

main "$@"
