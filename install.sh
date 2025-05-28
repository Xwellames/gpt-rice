#!/bin/bash

# Проверяем, что скрипт запущен от рута
if [ "$EUID" -ne 0 ]; then
    echo "Запусти скрипт от имени root (sudo)!"
    exit 1
fi

# Обновляем систему и ставим необходимые пакеты
echo "Обновляем систему и устанавливаем пакеты..."
pacman -Syu --noconfirm
pacman -S --noconfirm hyprland waybar kitty rofi dunst xdg-desktop-portal-hyprland \
    ttf-jetbrains-mono ttf-font-awesome sddm polkit-gnome \
    firefox thunar grim slurp wl-clipboard

# Устанавливаем AUR-хелпер (yay) для установки дополнительных пакетов
if ! command -v yay &> /dev/null; then
    echo "Устанавливаем yay..."
    pacman -S --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd -
fi

# Устанавливаем тему для SDDM (для красивого входа)
echo "Настраиваем SDDM с темой..."
yay -S --noconfirm sddm-theme-tokyo-night
mkdir -p /etc/sddm.conf.d
echo -e "[Theme]\nCurrent=tokyo-night" > /etc/sddm.conf.d/theme.conf
systemctl enable sddm

# Создаем директории для конфигов
echo "Создаем конфигурации для Hyprland..."
mkdir -p ~/.config/{hypr,waybar,kitty,rofi,dunst}

# Конфиг Hyprland (красно-черный минимализм)
cat << 'EOF' > ~/.config/hypr/hyprland.conf
# Основные настройки Hyprland
monitor=,preferred,auto,1
exec-once=waybar & dunst & polkit-gnome-authentication-agent-1

# Горячие клавиши
bind=SUPER,Return,exec,kitty
bind=SUPER,Q,killactive
bind=SUPER,M,exit
bind=SUPER,E,exec,thunar
bind=SUPER,F,exec,firefox
bind=SUPER,D,exec,rofi -show drun
bind=SUPER,Print,exec,grim - | wl-copy

# Стилизация окон
general {
    gaps_in=5
    gaps_out=10
    border_size=2
    col.active_border=rgb(ff0000) rgb(000000) 45deg
    col.inactive_border=rgb(333333)
}

decoration {
    rounding=5
    drop_shadow=true
    shadow_range=10
    shadow_render_power=3
    col.shadow=rgb(ff0000)
}

# Анимации
animations {
    enabled=true
    bezier=overshot,0.05,0.9,0.1,1.05
    animation=windows,1,5,overshot
    animation=border,1,10,default
    animation=fade,1,7,default
}

# Входные устройства
input {
    kb_layout=us,ru
    kb_options=grp:alt_shift_toggle
    follow_mouse=1
    touchpad {
        natural_scroll=true
    }
}
EOF

# Конфиг Waybar (панель в красно-черном стиле)
cat << 'EOF' > ~/.config/waybar/config
{
    "layer": "top",
    "position": "top",
    "height": 30,
    "modules-left": ["hyprland/workspaces"],
    "modules-center": ["clock"],
    "modules-right": ["cpu", "memory", "network", "tray"],
    "hyprland/workspaces": {
        "format": "{icon}",
        "format-icons": {
            "1": "1",
            "2": "2",
            "3": "3",
            "4": "4",
            "5": "5"
        }
    },
    "clock": {
        "format": "{:%H:%M}",
        "tooltip-format": "{:%Y-%m-%d | %H:%M}"
    },
    "cpu": {
        "format": "CPU {usage}%"
    },
    "memory": {
        "format": "MEM {}%"
    },
    "network": {
        "format-wifi": "{essid} ({signalStrength}%)",
        "format-ethernet": "ETH {ifname}",
        "format-disconnected": "Disconnected"
    },
    "tray": {
        "spacing": 10
    }
}
EOF

# Стили Waybar
cat << 'EOF' > ~/.config/waybar/style.css
* {
    font-family: JetBrains Mono, FontAwesome;
    font-size: 14px;
    color: #ffffff;
}

window#waybar {
    background: #1a1a1a;
    border-bottom: 2px solid #ff0000;
}

#workspaces button {
    padding: 0 5px;
    background: transparent;
    color: #ff0000;
    border: none;
}

#workspaces button:hover {
    background: #ff0000;
    color: #000000;
}

#clock, #cpu, #memory, #network, #tray {
    padding: 0 10px;
    background: #1a1a1a;
    color: #ff0000;
}
EOF

# Конфиг Kitty (терминал)
cat << 'EOF' > ~/.config/kitty/kitty.conf
font_family JetBrains Mono
font_size 12
background #1a1a1a
foreground # okien
cursor_color #ff0000
selection_background #ff0000
selection_foreground #000000
scrollback_lines 10000
enable_audio_bell no
EOF

# Конфиг Rofi
cat << 'EOF' > ~/.config/rofi/config.rasi
configuration {
    font: "JetBrains Mono 12";
    show-icons: true;
    icon-theme: "Papirus";
    display-drun: "Apps";
    display-window: "Windows";
    display-combi: "All";
}
window {
    background-color: #1a1a1a;
    text-color: #ff0000;
    border: 2px;
    border-color: #ff0000;
}
entry {
    background-color: #1a1a1a;
    text-color: #ffffff;
}
element {
    background-color: #1a1a1a;
    text-color: #ff0000;
}
element-icon {
    size: 24px;
}
EOF

# Конфиг Dunst (уведомления)
cat << 'EOF' > ~/.config/dunst/dunstrc
[global]
    font = JetBrains Mono 10
    frame_color = "#ff0000"
    background = "#1a1a1a"
    foreground = "#ff0000"
    timeout = 5
    geometry = "300x5-30+20"
    icon_position = left
    max_icon_size = 32
EOF

# Установка обоев (пример, замени путь на свои обои)
echo "Скачай обои в красно-черном стиле и положи их в ~/.wallpaper.png"
cat << 'EOF' > ~/.config/hypr/hyprpaper.conf
preload = ~/.wallpaper.png
wallpaper = ,~/.wallpaper.png
EOF

# Делаем скрипт исполняемым
chmod +x ~/.config/hypr/hyprland.conf
chmod +x ~/.config/waybar/config
chmod +x ~/.config/waybar/style.css
chmod +x ~/.config/kitty/kitty.conf
chmod +x ~/.config/rofi/config.rasi
chmod +x ~/.config/dunst/dunstrc
chmod +x ~/.config/hypr/hyprpaper.conf

echo "Установка завершена! Перезагрузи систему и выбери Hyprland в SDDM."
echo "Обои положи в ~/.wallpaper.png (PNG-файл в красно-черном стиле)."
EOF
