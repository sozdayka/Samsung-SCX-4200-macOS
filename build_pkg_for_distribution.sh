#!/bin/bash
# build_pkg.sh
# 1. Собирает component-пакет (обычный .pkg) из Payload и Scripts.
# 2. Результат кладёт в Packages/SamsungSCX4200Component.pkg

PKG_ID="com.sozdayka.samsung.scx4200"
PKG_VERSION="1.0"
OUTPUT_PKG="SamsungSCX4200Component.pkg"

ROOT_DIR="Payload"
SCRIPTS_DIR="Scripts"
PKG_OUTPUT_DIR="Packages"

mkdir -p "$PKG_OUTPUT_DIR"

echo "Собираем component-пакет $OUTPUT_PKG..."

pkgbuild \
  --root "$ROOT_DIR" \
  --scripts "$SCRIPTS_DIR" \
  --identifier "$PKG_ID" \
  --version "$PKG_VERSION" \
  "$PKG_OUTPUT_DIR/$OUTPUT_PKG"

if [ $? -eq 0 ]; then
  echo "Успех: собран $PKG_OUTPUT_DIR/$OUTPUT_PKG"
else
  echo "Ошибка при сборке component-пакета."
  exit 1
fi
