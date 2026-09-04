#!/bin/bash

# Скрипт для анализа популярных репозиториев на GitHub

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Проверка наличия curl и jq
if ! command -v curl &> /dev/null; then
    echo -e "${RED}Ошибка: curl не установлен!${NC}"
    echo "Установите curl: sudo apt install curl (Ubuntu) или choco install curl (Windows)"
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo -e "${RED}Ошибка: jq не установлен!${NC}"
    echo "Установите jq: sudo apt install jq (Ubuntu) или choco install jq (Windows)"
    exit 1
fi

# Проверка аргументов
if [ $# -eq 0 ]; then
    echo -e "${RED}Ошибка: укажите репозиторий!${NC}"
    echo "Использование: $0 owner/repo"
    echo "Пример: $0 tensorflow/tensorflow"
    exit 1
fi

REPO=$1
API_URL="https://api.github.com/repos/$REPO"

# Заголовок
echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║  🚀 GitHub Repository Analyzer       ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
echo ""

# Запрос к GitHub API
response=$(curl -s -w "%{http_code}" "$API_URL" 2>/dev/null)
http_code=${response: -3}
data=${response%???}

# Проверка ошибок
if [ "$http_code" -eq 404 ]; then
    echo -e "${RED}❌ Репозиторий '$REPO' не найден!${NC}"
    exit 1
elif [ "$http_code" -eq 403 ]; then
    echo -e "${RED}❌ Превышен лимит запросов к GitHub API!${NC}"
    echo "Попробуйте позже."
    exit 1
elif [ "$http_code" -ne 200 ]; then
    echo -e "${RED}❌ Ошибка API (HTTP $http_code)${NC}"
    exit 1
fi

# Парсинг данных
name=$(echo "$data" | jq -r '.full_name')
stars=$(echo "$data" | jq -r '.stargazers_count')
forks=$(echo "$data" | jq -r '.forks_count')
issues=$(echo "$data" | jq -r '.open_issues_count')
author=$(echo "$data" | jq -r '.owner.login')
updated_at=$(echo "$data" | jq -r '.updated_at')
description=$(echo "$data" | jq -r '.description')

# Форматирование чисел
stars_fmt=$(printf "%'d" "$stars")
forks_fmt=$(printf "%'d" "$forks")
issues_fmt=$(printf "%'d" "$issues")

# Определение цвета для issues
if [ "$issues" -gt 100 ]; then
    issues_color=$RED
else
    issues_color=$YELLOW
fi

# Определение активности
if [ -n "$updated_at" ]; then
    updated_seconds=$(date -d "$updated_at" +%s 2>/dev/null || echo "0")
    now_seconds=$(date +%s)
    diff_hours=$(( (now_seconds - updated_seconds) / 3600 ))
    
    if [ "$diff_hours" -lt 24 ]; then
        activity="${GREEN}Высокая (обновлён ${diff_hours} часов назад)${NC}"
    elif [ "$diff_hours" -lt 168 ]; then
        activity="${YELLOW}Средняя (обновлён $((diff_hours / 24)) дней назад)${NC}"
    else
        activity="${RED}Низкая (обновлён $((diff_hours / 24)) дней назад)${NC}"
    fi
else
    activity="${RED}Неизвестно${NC}"
fi

# Вывод результатов
echo -e "${BOLD}📦 Репозиторий:${NC} $name"
echo -e "${BOLD}📝 Описание:${NC} ${description:-Нет описания}"
echo -e "${YELLOW}⭐ Звёзды:       $stars_fmt${NC}"
echo -e "${GREEN}🔀 Форки:        $forks_fmt${NC}"
echo -e "${issues_color}🐛 Open Issues:  $issues_fmt${NC}"
echo -e "${BLUE}👤 Автор:        $author${NC}"
echo -e "${MAGENTA}📊 Активность:   $activity${NC}"
echo ""
echo -e "${CYAN}🔗 Ссылка: https://github.com/$REPO${NC}"