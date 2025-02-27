# #!/bin/bash
# set -e  # Останавливаем скрипт при ошибках

# PKG_ID="com.example.samsung.scx4200"
# PKG_VERSION="1.0"
# COMPONENT_PKG="SamsungSCX4200Component.pkg"

# ROOT_DIR="Payload"
# SCRIPTS_DIR="Scripts"

# PPD_SOURCE="SCX-4200.ppd"                 # Исходный PPD
# PPD_GZ_NAME="Samsung SCX-4200 Series.gz"  # Как назовём сжатый файл
# PPD_TARGET_DIR="$ROOT_DIR/Library/Printers/PPDs/Contents/Resources"

# echo "==> Сжимаем PPD..."
# mkdir -p "$PPD_TARGET_DIR"
# if [ -f "$PPD_SOURCE" ]; then
#   gzip -c "$PPD_SOURCE" > "$PPD_TARGET_DIR/$PPD_GZ_NAME"
# else
#   echo "Ошибка: файл $PPD_SOURCE не найден!"
#   exit 1
# fi

# echo "==> Собираем component-пакет $COMPONENT_PKG..."
# pkgbuild \
#   --root "$ROOT_DIR" \
#   --scripts "$SCRIPTS_DIR" \
#   --identifier "$PKG_ID" \
#   --version "$PKG_VERSION" \
#   "$COMPONENT_PKG"

# echo "==> Успех: создан $COMPONENT_PKG"

#!/bin/bash
# Скрипт для подготовки структуры Payload, сжатия PPD-файла и сборки установочного пакета (PKG)
# для принтера Samsung SCX-4200, используя структуру, близкую к официальным драйверам.

set -e  # Прерываем скрипт при ошибках

### 1. Настраиваем переменные проекта

PKG_ID="com.sozdayka.samsung.scx4200"
PKG_VERSION="1.0"
PKG_OUTPUT_DIR="Packages"
PKG_NAME="SamsungSCX4200Component.pkg"

ROOT_DIR="Payload"       # Папка, где хранится структура Library/... для установки
SCRIPTS_DIR="Scripts"    # Папка со скриптами (postinstall)

# Исходные файлы (имена могут отличаться в вашем проекте)
PPD_SOURCE="SCX-4200.ppd"                 # Исходный PPD (текстовый)
PPD_GZ_NAME="Samsung SCX-4200 Series.gz"  # Имя сжатого PPD-файла

# Папка, куда ляжет сжатый PPD в Payload
PPD_TARGET_DIR="$ROOT_DIR/Library/Printers/PPDs/Contents/Resources"

# Пример расположения HTML-справки (в корне проекта)
HELP_FILES=("About.html" "Output.html" "Printer.html" "Graphic.html")
HELP_TARGET_DIR="$ROOT_DIR/Library/Printers/Help/Samsung/SCX-4200/English"

# Пример расположения ресурсов
GRAY1D_FILE="Gray1D_600"
GRAYHT_FILE="GrayHT_600"
DRIVER_TARGET_DIR="$ROOT_DIR/Library/Printers/Samsung/SCX-4200"

# Иконка
ICON_SOURCE="SCX-4200.icns"
ICON_TARGET_DIR="$ROOT_DIR/Library/Printers/Samsung/Icons"

# Пример драйвера сканера
SCANNER_APP_SOURCE="Samsung Scanner.app"
SCANNER_TARGET_DIR="$ROOT_DIR/Library/Image Capture/Devices"

echo "=== Сборка пакета $PKG_NAME для Samsung SCX-4200 ==="

### 2. Проверяем, что каталоги Payload и Scripts существуют
if [ ! -d "$ROOT_DIR" ]; then
  echo "Ошибка: каталог '$ROOT_DIR' не найден. Создайте его или обновите переменную ROOT_DIR."
  exit 1
fi

if [ ! -d "$SCRIPTS_DIR" ]; then
  echo "Ошибка: каталог '$SCRIPTS_DIR' не найден. Создайте его или обновите переменную SCRIPTS_DIR."
  exit 1
fi

### 3. Подготавливаем структуру в Payload

echo "==> Подготавливаем структуру каталогов в Payload..."

# Создаём папку для PPD, если её нет
mkdir -p "$PPD_TARGET_DIR"

# Создаём папку для HTML-справки
mkdir -p "$HELP_TARGET_DIR"

# Создаём папку для ресурсов тонов
mkdir -p "$DRIVER_TARGET_DIR"

# Создаём папку для иконки
mkdir -p "$ICON_TARGET_DIR"

# Создаём папку для сканера
mkdir -p "$SCANNER_TARGET_DIR"

echo "Структура каталогов подготовлена."

### 4. Сжимаем PPD-файл в .gz и копируем в нужное место

if [ -f "$PPD_SOURCE" ]; then
  echo "==> Сжимаем PPD '$PPD_SOURCE' в '$PPD_GZ_NAME'..."
  gzip -c "$PPD_SOURCE" > "$PPD_TARGET_DIR/$PPD_GZ_NAME"
  echo "PPD сжат и помещён в $PPD_TARGET_DIR/$PPD_GZ_NAME"
else
  echo "Ошибка: исходный PPD '$PPD_SOURCE' не найден!"
  exit 1
fi

### 5. Копируем HTML-файлы справки

echo "==> Копируем HTML-справку..."
for f in "${HELP_FILES[@]}"; do
  if [ -f "$f" ]; then
    cp "$f" "$HELP_TARGET_DIR/"
    echo "Скопирован $f в $HELP_TARGET_DIR"
  else
    echo "Предупреждение: файл '$f' не найден, пропускаем."
  fi
done

### 6. Копируем ресурсы тонов (Gray1D_600, GrayHT_600)

if [ -f "$GRAY1D_FILE" ]; then
  cp "$GRAY1D_FILE" "$DRIVER_TARGET_DIR/"
  echo "Скопирован $GRAY1D_FILE в $DRIVER_TARGET_DIR"
fi

if [ -f "$GRAYHT_FILE" ]; then
  cp "$GRAYHT_FILE" "$DRIVER_TARGET_DIR/"
  echo "Скопирован $GRAYHT_FILE в $DRIVER_TARGET_DIR"
fi

### 7. Копируем иконку (SCX-4200.icns)

if [ -f "$ICON_SOURCE" ]; then
  cp "$ICON_SOURCE" "$ICON_TARGET_DIR/"
  echo "Скопирован $ICON_SOURCE в $ICON_TARGET_DIR"
else
  echo "Предупреждение: иконка '$ICON_SOURCE' не найдена, пропускаем."
fi

### 8. Копируем драйвер сканера (Samsung Scanner.app), если он есть

if [ -d "$SCANNER_APP_SOURCE" ]; then
  cp -R "$SCANNER_APP_SOURCE" "$SCANNER_TARGET_DIR/"
  echo "Скопирован сканер $SCANNER_APP_SOURCE в $SCANNER_TARGET_DIR"
else
  echo "Предупреждение: папка '$SCANNER_APP_SOURCE' не найдена, пропускаем."
fi

### 9. Вызываем pkgbuild для сборки пакета

echo "==> Создаём установочный пакет '$PKG_NAME'..."

pkgbuild \
  --root "$ROOT_DIR" \
  --scripts "$SCRIPTS_DIR" \
  --identifier "$PKG_ID" \
  --version "$PKG_VERSION" \
  "$PKG_OUTPUT_DIR/$PKG_NAME"

if [ $? -eq 0 ]; then
  echo "Успех: пакет '$PKG_NAME' создан."
  echo "Установите пакет двойным кликом или командой: sudo installer -pkg $PKG_NAME -target /"
else
  echo "Ошибка при создании пакета."
  exit 1
fi

echo "==> Сборка завершена."
