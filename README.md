# 💥 Hyperland Red-Black Setup for Arch Linux

> 🧨 Превращает твой Arch в супер-минималистичную, стильную, красно-чёрную пушку-бомбу на Hyperland!

---

## 🧠 Что делает скрипт

- ⏫ Устанавливает **Hyprland** и все нужные пакеты
- 🎨 Применяет **красно-чёрную тему** (GTK, иконки, шрифты, обои)
- ⚙️ Автоматически настраивает:
  - Hyprland (с конфигами, анимациями, биндами)
  - Waybar (панель)
  - Wofi (меню запуска)
  - PipeWire + WirePlumber (звук)
  - `swww` (обои)
  - GTK и QT стили через `qt5ct`, `nwg-look`
  - Автозапуск нужных компонентов через `exec-once`
- 🔋 Работает на **чистом Arch Linux (Wayland)**

---

## 🚀 Быстрый старт


git clone https://github.com/Xwellames/gpt-rice.git
cd gpt-rice
chmod +x install.sh
./install.sh

## ⌨️ Бинды
SUPER + Q             — Закрыть окно
SUPER + RETURN        — Терминал (Kitty)
SUPER + SPACE         — Меню запуска (Wofi)
SUPER + ESC           — Перезапустить Hyprland
SUPER + SHIFT + R     — Перезапуск Waybar
SUPER + 1-9           — Рабочие столы
SUPER + SHIFT + 1-9   — Переместить окно
PRINT                 — Скриншот (grim + slurp)
