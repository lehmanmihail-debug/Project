#!/bin/bash

# ==============================================
# Скрипт синхронизации Git-репозиториев (Bash)
# ==============================================

# Цвета для вывода
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Функция для вывода сообщений
print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# ==============================================
# НАСТРОЙКИ (ИЗМЕНИТЕ ПУТИ ПОД СЕБЯ!)
# ==============================================

# Путь к исходному репозиторию (откуда берем изменения)
SOURCE_REPO="/GitHub/mfua"

# Путь к целевому репозиторию (куда копируем)
TARGET_REPO="/GitHub/Project"

# Выполнять ли git push в целевом репозитории? (true/false)
ENABLE_PUSH=false

# Обрабатывать приватные репозитории? (true/false)
# Если true, скрипт будет пытаться пуллить даже при ошибках аутентификации
HANDLE_PRIVATE=false

# ==============================================
# ПРОВЕРКА ПУТЕЙ
# ==============================================

print_step "Проверка конфигурации..."

# Проверка существования исходного репозитория
if [ ! -d "$SOURCE_REPO" ]; then
    print_error "Исходный репозиторий не найден: $SOURCE_REPO"
    exit 1
fi

if [ ! -d "$SOURCE_REPO/.git" ]; then
    print_error "В исходном пути не найден .git. Убедитесь, что это Git-репозиторий: $SOURCE_REPO"
    exit 1
fi

# Проверка существования целевого репозитория
if [ ! -d "$TARGET_REPO" ]; then
    print_error "Целевой репозиторий не найден: $TARGET_REPO"
    exit 1
fi

# Создаем целевой репозиторий, если это не Git-репозиторий
if [ ! -d "$TARGET_REPO/.git" ]; then
    print_warning "Целевой путь не является Git-репозиторием. Инициализируем..."
    cd "$TARGET_REPO" && git init
    if [ $? -ne 0 ]; then
        print_error "Не удалось инициализировать Git в целевой директории"
        exit 1
    fi
fi

print_message "Исходный репозиторий: $SOURCE_REPO"
print_message "Целевой репозиторий: $TARGET_REPO"
print_message "Git push: $ENABLE_PUSH"
print_message "Обработка приватных: $HANDLE_PRIVATE"
echo ""

# ==============================================
# 1. GIT PULL В ИСХОДНОМ РЕПОЗИТОРИИ
# ==============================================

print_step "Обновление исходного репозитория..."

cd "$SOURCE_REPO" || exit 1

# Проверка наличия удаленного репозитория
if git remote -v | grep -q origin; then
    print_message "Выполняем git pull origin..."
    
    # Пытаемся выполнить pull
    git pull origin 2>&1 | tee /tmp/git_output.tmp
    GIT_RESULT=${PIPESTATUS[0]}
    
    # Проверка на ошибки аутентификации для приватных репозиториев
    if [ $GIT_RESULT -ne 0 ]; then
        if [ "$HANDLE_PRIVATE" = true ]; then
            if grep -q "Authentication failed\|Permission denied\|could not read" /tmp/git_output.tmp; then
                print_warning "Обнаружена проблема с доступом к приватному репозиторию"
                print_message "Продолжаем с локальной копией (без обновления)..."
            else
                print_error "Ошибка git pull (не связанная с приватностью)"
                exit 1
            fi
        else
            print_error "Ошибка git pull. Проверьте подключение к интернету и права доступа."
            exit 1
        fi
    fi
    rm -f /tmp/git_output.tmp
else
    print_warning "Нет удаленного репозитория 'origin'. Пропускаем git pull."
fi

# ==============================================
# 2. КОПИРОВАНИЕ (ИСКЛЮЧАЯ .GIT)
# ==============================================

print_step "Копирование содержимого в целевой репозиторий..."

# Копируем все файлы, кроме .git
# Используем rsync (если доступен) для лучшей производительности
if command -v rsync &> /dev/null; then
    print_message "Используем rsync для копирования..."
    rsync -av --delete --exclude='.git' "$SOURCE_REPO/" "$TARGET_REPO/"
    COPY_RESULT=$?
else
    print_warning "rsync не найден, используем cp (медленнее)..."
    
    # Сначала удаляем все в целевой папке кроме .git
    print_message "Очищаем целевую папку (кроме .git)..."
    find "$TARGET_REPO" -mindepth 1 -not -path "$TARGET_REPO/.git*" -exec rm -rf {} + 2>/dev/null
    
    # Копируем все из исходной папки кроме .git
    print_message "Копируем файлы..."
    cp -a "$SOURCE_REPO/." "$TARGET_REPO/"
    # Удаляем скопированную папку .git в целевой папке, если она появилась
    rm -rf "$TARGET_REPO/.git" 2>/dev/null
    COPY_RESULT=$?
fi

if [ $COPY_RESULT -ne 0 ]; then
    print_error "Ошибка при копировании файлов"
    exit 1
fi

print_message "Копирование завершено успешно"

# ==============================================
# 3. ОПЦИОНАЛЬНЫЙ GIT PUSH В ЦЕЛЕВОМ РЕПОЗИТОРИИ
# ==============================================

if [ "$ENABLE_PUSH" = true ]; then
    print_step "Выполняем git push в целевом репозитории..."
    
    cd "$TARGET_REPO" || exit 1
    
    # Проверка, есть ли что коммитить
    if git status --porcelain | grep -q .; then
        print_message "Обнаружены изменения. Создаем коммит..."
        
        # Добавляем все изменения
        git add -A
        
        # Создаем коммит с датой
        git commit -m "Auto-sync: $(date '+%Y-%m-%d %H:%M:%S')"
        
        if [ $? -eq 0 ]; then
            # Пытаемся запушить
            if git remote -v | grep -q origin; then
                git push origin
                if [ $? -eq 0 ]; then
                    print_message "Git push выполнен успешно"
                else
                    print_error "Ошибка git push"
                    exit 1
                fi
            else
                print_warning "Нет удаленного репозитория 'origin' для пуша"
            fi
        fi
    else
        print_message "Нет изменений для коммита"
    fi
fi

# ==============================================
# ЗАВЕРШЕНИЕ
# ==============================================

echo ""
print_message "✅ Синхронизация успешно завершена!"
print_message "Исходный репозиторий: $SOURCE_REPO"
print_message "Целевой репозиторий: $TARGET_REPO"

exit 0