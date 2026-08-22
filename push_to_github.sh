#!/bin/sh
# Однократный скрипт: инициализирует папку как git-репозиторий,
# подтягивает существующий main из GitHub и пушит содержимое поверх него.
# Запуск: sh push_to_github.sh   (из папки wm_animated_ha_card)
set -e
cd "$(dirname "$0")"

git init -b main 2>/dev/null || true
git remote add origin https://github.com/sionetta/wm_animated_ha_card.git 2>/dev/null || true
git fetch origin
# ставим HEAD на удалённый main, не трогая файлы в папке
git reset --mixed origin/main
git add -A
# скрипт не должен попасть в репозиторий
git rm --cached push_to_github.sh -q 2>/dev/null || true
git commit -m "Washing Machine Animated Card v1.0.0

Oikos-style animated Lovelace card for a washing machine on a smart plug:
animated SVG machine, live status with elapsed-time ring, power gauge,
last-cycle stats (start / duration / energy / cost), EN+RU localization.
Includes bilingual README, demo video/GIF, example HA package, MIT license,
and hacs.json for HACS custom-repository installs."
git push origin main
echo ""
echo "=== Готово! Проверьте https://github.com/sionetta/wm_animated_ha_card ==="
echo "=== Файл push_to_github.sh теперь можно удалить ==="
