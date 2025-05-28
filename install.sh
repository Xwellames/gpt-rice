#!/bin/bash

set -e

# 1. Установка необходимых пакетов
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm \
  hyprland waybar wofi kitty swww grim slurp \
  pipewire wireplumber xdg-desktop-portal-hyprland \
  qt5-wayland qt6-wayland qt5ct qt6ct \
  lxappearance nwg-look papirus-icon-theme \
  ttf-jetbrains-mono-nerd unzip curl git

# 2. Создание директорий
mkdir -p ~/.config/hypr ~/.config/waybar ~/.config/wofi ~/.config/gtk-3.0 ~/.config/gtk-4.0 ~/.fonts ~/.icons ~/.themes ~/Pictures

# 3. Установка обоев (красно-чёрный стиль)
curl -Lo ~/Pictures/wallpaper.png "https://w.wallhaven.cc/full/2y/wallhaven-2y3g7k.png"

# 4. Конфиг Hyprland
cat > ~/.config/hypr/hyprland.conf <<EOF
exec-once = swww init
exec-once = swww img ~/Pictures/wallpaper.png
exec-once = waybar
exec-once = wofi &
exec-once = wireplumber
exec-once = sleep 1 && hyprctl setcursor Bibata-Original-Classic 24

$mod = SUPER

bind = $mod, RETURN, exec, kitty
bind = $mod, Q, killactive,
bind = $mod, SPACE, exec, wofi --show drun
bind = $mod, ESCAPE, exec, hyprctl reload
bind = $mod SHIFT, R, exec, pkill waybar && waybar &
bind = , Print, exec, grim -g "$(slurp)" - | wl-copy

bind = $mod, 1, workspace, 1
bind = $mod, 2, workspace, 2
bind = $mod, 3, workspace, 3
bind = $mod, 4, workspace, 4
bind = $mod, 5, workspace, 5
bind = $mod, 6, workspace, 6
bind = $mod, 7, workspace, 7
bind = $mod, 8, workspace, 8
bind = $mod, 9, workspace, 9
bind = $mod SHIFT, 1, movetoworkspace, 1
bind = $mod SHIFT, 2, movetoworkspace, 2
bind = $mod SHIFT, 3, movetoworkspace, 3
bind = $mod SHIFT, 4, movetoworkspace, 4
bind = $mod SHIFT, 5, movetoworkspace, 5
bind = $mod SHIFT, 6, movetoworkspace, 6
bind = $mod SHIFT, 7, movetoworkspace, 7
bind = $mod SHIFT, 8, movetoworkspace, 8
bind = $mod SHIFT, 9, movetoworkspace, 9

input {
    kb_layout = us
}

general {
    gaps_in = 5
    gaps_out = 15
    border_size = 2
    col.active_border = rgba(ff0000ee)
    col.inactive_border = rgba(000000aa)
}

decoration {
    rounding = 10
    blur {
        enabled = true
        size = 5
        passes = 3
    }
}

animations {
    enabled = true
    bezier = myBezier, 0.05, 0.9, 0.1, 1.0
    animation = windows, 1, 7, myBezier
    animation = fade, 1, 7, myBezier
    animation = border, 1, 7, default
    animation = workspaces, 1, 7, default
}
EOF

# 5. Конфиг Waybar
cat > ~/.config/waybar/config <<EOF
{
  "layer": "top",
  "position": "top",
  "modules-left": ["workspaces"],
  "modules-center": ["clock"],
  "modules-right": ["pulseaudio", "tray"],

  "workspaces": {},
  "clock": {
    "format": "%a %d %b %H:%M"
  },
  "pulseaudio": {
    "format": "VOL: {volume}%"
  },
  "tray": {}
}
EOF

cat > ~/.config/waybar/style.css <<EOF
* {
  border: none;
  border-radius: 0;
  font-family: JetBrainsMono Nerd Font;
  font-size: 14px;
  padding: 0 10px;
  color: #ff5555;
  background-color: #111111;
}
EOF

# 6. Конфиг Wofi
cat > ~/.config/wofi/config <<EOF
prompt=Run:
show=drun
drun-show-actions=false
EOF

# 7. GTK иконки и тема (через lxappearance/nwg-look)
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface font-name 'JetBrainsMono Nerd Font 11'

# 8. Добавляем Hyprland в автозапуск
if ! grep -q "exec Hyprland" ~/.zprofile 2>/dev/null; then
  echo "exec Hyprland" >> ~/.zprofile
fi

# 9. Предложение перезагрузки
read -rp $'\n🎉 Установка завершена! Перезагрузить систему сейчас? (y/N): ' answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
  reboot
else
  echo "🚀 Просто перезагрузи позже, чтобы войти в Hyprland."
fi
