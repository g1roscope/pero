#!/usr/bin/env bash
# pero — установка зависимостей, сборка и установка
set -e
cd "$(dirname "$0")"

SUDO=""
if [ "$(id -u)" -ne 0 ]; then
    SUDO="sudo"
    command -v sudo >/dev/null || { echo "нужен root или sudo"; exit 1; }
fi

echo "==> Устанавливаю зависимости..."
if command -v apt-get >/dev/null 2>&1; then
    $SUDO apt-get update
    if apt-cache show libwebkit2gtk-4.1-dev >/dev/null 2>&1; then
        $SUDO apt-get install -y build-essential pkg-config libgtk-3-dev libwebkit2gtk-4.1-dev
    else
        $SUDO apt-get install -y build-essential pkg-config libgtk-3-dev libwebkit2gtk-4.0-dev
    fi
elif command -v dnf >/dev/null 2>&1; then
    $SUDO dnf install -y gcc make pkgconf-pkg-config gtk3-devel webkit2gtk4.1-devel \
        || $SUDO dnf install -y gcc make pkgconf-pkg-config gtk3-devel webkit2gtk4.0-devel
elif command -v pacman >/dev/null 2>&1; then
    $SUDO pacman -S --needed --noconfirm base-devel pkgconf gtk3 webkit2gtk-4.1
elif command -v zypper >/dev/null 2>&1; then
    $SUDO zypper install -y gcc make pkg-config gtk3-devel webkit2gtk4-devel \
        || $SUDO zypper install -y gcc make pkg-config gtk3-devel webkit2gtk3-devel
else
    echo "не нашёл пакетный менеджер: установите вручную gtk3 и webkit2gtk (dev-пакеты)"
    exit 1
fi

echo "==> Собираю..."
make

echo "==> Устанавливаю..."
$SUDO make install

if command -v gtk-update-icon-cache >/dev/null 2>&1; then
    $SUDO gtk-update-icon-cache -f /usr/local/share/icons/hicolor 2>/dev/null || true
fi

echo
echo "========================================"
echo "  Готово! Браузер установлен."
echo "========================================"
echo
echo "  Запуск:     pero"
echo "  Киоск:      pero -k"
echo "  Из меню:    найдите «pero»"
