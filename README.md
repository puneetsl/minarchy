# Minarchy

Minimal Hyprland configuration inspired by [Omarchy](https://github.com/basecamp/omarchy) - but for any Hyprland-based Linux distro.

![Hyprland](https://img.shields.io/badge/Hyprland-Wayland-blue)
![Arch](https://img.shields.io/badge/Arch-Based-1793D1)
![License](https://img.shields.io/badge/License-MIT-green)

## Features

- **Minimal glassmorphism design** - Floating waybar with blur effects
- **Minarchy keybindings** - Intuitive Super key shortcuts
- **Universal clipboard** - Super+C/V/X works everywhere, including terminal
- **Smart menu system** - Quick access to settings, apps, and system controls
- **Organized wallpapers** - Category-based wallpaper management
- **fzf package search** - Interactive Pacman/AUR package installation

## Screenshots

*Coming soon*

## Installation

### Quick Install (Arch-based distros)

```bash
git clone https://github.com/yourusername/minarchy.git
cd minarchy
./install.sh
```

### Manual Install

1. Install dependencies:
```bash
sudo pacman -S hyprland hyprlock hypridle waybar mako wofi swww kitty \
  wl-clipboard cliphist grim slurp swappy wf-recorder hyprpicker \
  pavucontrol brightnessctl ttf-jetbrains-mono-nerd polkit-gnome fzf
```

2. Copy configs:
```bash
cp -r config/hypr/* ~/.config/hypr/
cp -r config/waybar/* ~/.config/waybar/
cp -r config/wofi/* ~/.config/wofi/
cp -r config/mako/* ~/.config/mako/
chmod +x ~/.config/wofi/scripts/*.sh
chmod +x ~/.config/waybar/scripts/*.sh
```

3. Log out and select Hyprland from your display manager.

## Key Bindings

### Applications
| Key | Action |
|-----|--------|
| `Super + Return` | Terminal (kitty) |
| `Super + Space` | App Launcher (wofi) |
| `Super + Alt + Space` | Minarchy Menu |
| `Super + Shift + B` | Browser |
| `Super + Shift + F` | File Manager |
| `Super + Shift + N` | Neovim |
| `Super + Shift + T` | System Monitor (btop) |

### Window Management
| Key | Action |
|-----|--------|
| `Super + W` | Close Window |
| `Super + F` | Fullscreen |
| `Super + Alt + F` | Maximize |
| `Super + T` | Toggle Floating |
| `Super + J` | Toggle Split |
| `Super + Arrow Keys` | Focus Window |
| `Super + Shift + Arrow Keys` | Swap Window |
| `Super + +/-` | Resize Horizontally |
| `Super + Shift + +/-` | Resize Vertically |

### Workspaces
| Key | Action |
|-----|--------|
| `Super + 1-0` | Switch to Workspace |
| `Super + Shift + 1-0` | Move Window to Workspace |
| `Super + Tab` | Next Workspace |
| `Super + Shift + Tab` | Previous Workspace |
| `Super + S` | Scratchpad |

### Clipboard & Edit
| Key | Action |
|-----|--------|
| `Super + C` | Copy |
| `Super + V` | Paste |
| `Super + X` | Cut |
| `Super + A` | Select All |
| `Super + Z` | Undo |
| `Super + Ctrl + V` | Clipboard History |

### Screenshots & Capture
| Key | Action |
|-----|--------|
| `Print` | Screenshot (select area) |
| `Shift + Print` | Screenshot (full, to clipboard) |
| `Super + Print` | Color Picker |
| `Alt + Print` | Screen Record |

### System
| Key | Action |
|-----|--------|
| `Super + Escape` | Power Menu |
| `Super + Ctrl + L` | Lock Screen |
| `Super + ,` | Dismiss Notification |
| `Super + Shift + ,` | Dismiss All Notifications |

## Minarchy Menu

Press `Super + Alt + Space` for quick access to:

- **Apps** - Application launcher
- **Learn** - Keybindings reference, wiki links
- **Capture** - Screenshots, recordings, color picker
- **Toggle** - Nightlight, idle lock, waybar, blur
- **Style** - Themes, wallpapers, config editors
- **Setup** - Audio, WiFi, Bluetooth, displays
- **Install** - fzf-powered package search (Pacman + AUR)
- **Update** - System updates, mirror refresh
- **System** - Lock, suspend, reboot, shutdown

## Wallpapers

Wallpapers are organized in categories:
```
~/Pictures/wallpapers/
├── Tokyo/
├── Cyberpunk/
├── Nature/
└── Abstract/
```

Access via Menu → Style → Wallpaper, or add your own images to these folders.

## Customization

### Colors

Edit waybar colors in `~/.config/waybar/style.css`:
```css
@define-color accent #89b4fa;
@define-color bg rgba(20, 20, 30, 0.6);
```

Edit Hyprland border colors in `~/.config/hypr/hyprland.conf`:
```
$activeBorderColor = rgba(33ccffee) rgba(00ff99ee) 45deg
```

### Gaps & Borders

In `~/.config/hypr/hyprland.conf`:
```
general {
    gaps_in = 1
    gaps_out = 2
    border_size = 1
}
```

## Dependencies

- **hyprland** - Wayland compositor
- **waybar** - Status bar
- **wofi** - Application launcher
- **mako** - Notification daemon
- **swww** - Wallpaper daemon
- **kitty** - Terminal emulator
- **hyprlock/hypridle** - Lock screen & idle management
- **grim/slurp/swappy** - Screenshot tools
- **wf-recorder** - Screen recording
- **wl-clipboard/cliphist** - Clipboard management
- **paru/yay** - AUR helper (optional)

## Credits

- Inspired by [Omarchy](https://github.com/basecamp/omarchy) by Basecamp
- Built for [Hyprland](https://hyprland.org/)
- Tested on [CachyOS](https://cachyos.org/)

## License

MIT
