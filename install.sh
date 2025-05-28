
---

## 🧨 `install.sh` (с выбором перезагрузки)

```bash
#!/bin/bash

# Проверка на root
if [[ "$EUID" -eq 0 ]]; then
  echo "❌ Не запускай скрипт от root!"
  exit 1
fi

echo "🚀 Начинаем установку Hyperland Red-Black Setup..."

# Установка зависимостей
echo "📦 Установка пакетов..."
sudo pacman -Syu --noconfirm hyprland waybar wofi kitty swww grim slurp \
  pipewire wireplumber xdg-desktop-portal-hyprland \
  qt5-wayland qt6-wayland qt5ct qt6ct \
  lxappearance nwg-look papirus-icon-theme \
  ttf-jetbrains-mono-nerd unzip curl git

# Копирование конфигов
echo "⚙️ Копируем конфиги..."
mkdir -p ~/.config/hypr ~/.config/waybar ~/.config/wofi ~/.config/gtk-3.0 ~/Pictures/wallpapers

cp -r ./config/hypr/* ~/.config/hypr/
cp -r ./config/waybar/* ~/.config/waybar/
cp -r ./config/wofi/* ~/.config/wofi/
cp -r ./themes/gtk-3.0/* ~/.config/gtk-3.0/
cp -r ./wallpapers/* ~/Pictures/wallpapers/

# Настройка темы и иконок
echo "🎨 Настройка темы и иконок..."
gsettings set org.gnome.desktop.interface gtk-theme "Colloid-Dark"
gsettings set org.gnome.desktop.interface icon-theme "Tela-red"
gsettings set org.gnome.desktop.interface font-name "JetBrainsMono Nerd Font 11"

# Добавляем в zprofile запуск Hyprland, если не добавлено
if ! grep -q "exec Hyprland" ~/.zprofile; then
  echo "exec Hyprland" >> ~/.zprofile
fi

echo "✅ Установка завершена!"

# Выбор: перезагрузить или нет
read -p "🔁 Перезагрузить систему сейчас? [Y/n]: " answer
case "${answer,,}" in
  y|"") echo "♻️ Перезагрузка..."; sleep 2; reboot ;;
  n) echo "👌 Перезагрузи позже вручную" ;;
  *) echo "⚠️ Неверный ввод. Перезагрузи позже вручную." ;;
esac
