#!/bin/bash

set -e

echo -e "\n🔧 Устанавливаем зависимости..."
sudo pacman -Syu --noconfirm \
  hyprland waybar wofi kitty \
  qt5-wayland qt6-wayland \
  pipewire wireplumber \
  xdg-desktop-portal-hyprland \
  grim slurp wl-clipboard \
  nwg-look qt5ct qt6ct \
  ttf-jetbrains-mono-nerd \
  lxappearance papirus-icon-theme \
  swww unzip curl git

echo -e "\n🧰 Клонируем конфиги..."
mkdir -p ~/.config
cd ~/.config
git clone https://github.com/hyprwm/Hyprland ~/.config/hypr 2>/dev/null || true
git clone https://github.com/Alexays/Waybar ~/.config/waybar 2>/dev/null || true

echo -e "\n🎨 Устанавливаем тему и иконки..."
mkdir -p ~/.themes ~/.icons ~/Pictures/wallpapers
curl -L https://github.com/vinceliuice/Colloid-gtk-theme/archive/refs/heads/master.zip -o colloid.zip
unzip -q colloid.zip && mv Colloid* ~/.themes && rm -f colloid.zip

curl -L https://github.com/vinceliuice/Tela-icon-theme/archive/refs/heads/master.zip -o tela.zip
unzip -q tela.zip && mv Tela* ~/.icons && rm -f tela.zip

echo -e "\n🖼️ Добавляем обои..."
curl -L https://w.wallhaven.cc/full/1p/wallhaven-1p3g9l.jpg -o ~/Pictures/wallpapers/redblack.jpg

echo -e "\n⚙️ Настраиваем swww и фон..."
mkdir -p ~/.config/hypr
cat > ~/.config/hypr/hyprland.conf <<EOF
exec-once = swww init && swww img ~/Pictures/wallpapers/redblack.jpg --transition-type any

monitor=,preferred,auto,1
input {
    kb_layout=us
}
general {
    gaps_in=5
    gaps_out=10
    border_size=2
    col.active_border=0xffcc0000
    col.inactive_border=0xff111111
    layout=dwindle
    no_cursor_warps=true
}
decoration {
    rounding=10
    blur {
        enabled=true
        size=8
        passes=3
    }
    drop_shadow=true
    shadow_range=20
    shadow_render_power=3
    col.shadow=0x99000000
}
animations {
    enabled=true
    bezier=pop,0.16,1,0.3,1
    animation=windows,1,7,default,slide
    animation=fade,1,4,default
}
EOF

echo -e "\n📦 Настраиваем Waybar..."
mkdir -p ~/.config/waybar
cat > ~/.config/waybar/style.css <<EOF
* {
  font-family: JetBrainsMono Nerd Font;
  font-size: 13px;
  background: transparent;
  color: #ff0000;
}
#window, #workspaces, #clock, #tray {
  background-color: #111111;
  padding: 5px 10px;
  border-radius: 10px;
}
EOF

cat > ~/.config/waybar/config <<EOF
{
  "layer": "top",
  "modules-left": ["workspaces"],
  "modules-center": ["clock"],
  "modules-right": ["tray"],
  "clock": {
    "format": "{:%H:%M}"
  }
}
EOF

echo -e "\n📟 Настраиваем Wofi..."
mkdir -p ~/.config/wofi
cat > ~/.config/wofi/style.css <<EOF
window {
  background-color: #111111;
  border: 2px solid #cc0000;
  color: #ffffff;
}
EOF

cat > ~/.config/wofi/config <<EOF
show-icons=true
prompt=
insensitive=true
allow-markup=true
EOF

echo -e "\n🔚 Готово! Добавь это в .bash_profile или .zprofile:"
echo -e "\nexec Hyprland"

echo -e "\n🚀 Перезапускайся и наслаждайся пушкой-бомбой в красно-чёрном стиле! 🔥"
