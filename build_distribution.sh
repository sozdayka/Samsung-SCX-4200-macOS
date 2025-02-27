#!/bin/bash
set -e

DIST_XML="Distribution.xml"
RESOURCES_DIR="Resources"
PKG_OUTPUT_DIR="Packages"
COMPONENT_PKG="SamsungSCX4200Component.pkg"
OUTPUT_DISTRIB="SamsungSCX4200-Installer-Distribution.pkg"

echo "==> Проверяем наличие component-пакета..."
if [ ! -f  "$PKG_OUTPUT_DIR/$COMPONENT_PKG" ]; then
  echo "Ошибка: не найден $COMPONENT_PKG. Сначала запустите build_pkg.sh."
  exit 1
fi

echo "==> Собираем distribution-пакет $OUTPUT_DISTRIB..."
productbuild \
  --distribution "$DIST_XML" \
  --resources "$RESOURCES_DIR" \
  --package-path "$PKG_OUTPUT_DIR" \
  "$OUTPUT_DISTRIB"

echo "Успех: создан $OUTPUT_DISTRIB"
echo "Откройте $OUTPUT_DISTRIB для установки."

# #!/bin/bash
# set -e

# PKG_OUTPUT_DIR="Packages"
# PKG_NAME="SamsungSCX4200Installer.pkg"

# echo "==> Создаём красивый установщик с кастомными экранами..."

# productbuild \
#     --distribution Distribution.xml \
#     --package-path . \
#     --resources . \
#     "$PKG_OUTPUT_DIR/$PKG_NAME"

# echo "✅ Установочный пакет '$PKG_NAME' создан!"
