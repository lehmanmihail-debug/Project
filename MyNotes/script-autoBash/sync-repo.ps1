<#
.SYNOPSIS
    Скрипт синхронизации Git-репозиториев (PowerShell)
.DESCRIPTION
    Выполняет git pull в исходном репозитории и копирует содержимое (кроме .git) в целевой репозиторий
.NOTES
    Требуется Git для Windows
#>

# ==============================================
# НАСТРОЙКИ (ИЗМЕНИТЕ ПУТИ ПОД СЕБЯ!)
# ==============================================

# Путь к исходному репозиторию (откуда берем изменения)
$SOURCE_REPO = "C:\GitHub\mfua"

# Путь к целевому репозиторию (куда копируем)
$TARGET_REPO = "C:\GitHub\Project"

# Выполнять ли git push в целевом репозитории? ($true/$false)
$ENABLE_PUSH = $false

# Обрабатывать приватные репозитории? ($true/$false)
$HANDLE_PRIVATE = $false

# Открывать окно терминала для визуального контроля?
$SHOW_TERMINAL = $true

# ==============================================
# ФУНКЦИИ ДЛЯ ВЫВОДА
# ==============================================

function Write-Step {
    param([string]$Message)
    Write-Host "[STEP] $Message" -ForegroundColor Blue
}

function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# ==============================================
# ПРОВЕРКА GIT
# ==============================================

# Проверяем наличие git в системе
try {
    $gitVersion = git --version
    Write-Info "Найден Git: $gitVersion"
}
catch {
    Write-Error "Git не найден. Установите Git для Windows: https://git-scm.com/download/win"
    if ($SHOW_TERMINAL) {
        Read-Host "Нажмите Enter для выхода"
    }
    exit 1
}

# ==============================================
# ПРОВЕРКА ПУТЕЙ
# ==============================================

Write-Step "Проверка конфигурации..."

# Проверка существования исходного репозитория
if (-not (Test-Path $SOURCE_REPO)) {
    Write-Error "Исходный репозиторий не найден: $SOURCE_REPO"
    if ($SHOW_TERMINAL) { Read-Host "Нажмите Enter для выхода" }
    exit 1
}

if (-not (Test-Path "$SOURCE_REPO\.git")) {
    Write-Error "В исходном пути не найден .git. Убедитесь, что это Git-репозиторий: $SOURCE_REPO"
    if ($SHOW_TERMINAL) { Read-Host "Нажмите Enter для выхода" }
    exit 1
}

# Проверка существования целевого репозитория
if (-not (Test-Path $TARGET_REPO)) {
    Write-Error "Целевой репозиторий не найден: $TARGET_REPO"
    if ($SHOW_TERMINAL) { Read-Host "Нажмите Enter для выхода" }
    exit 1
}

# Инициализация Git в целевом репозитории при необходимости
if (-not (Test-Path "$TARGET_REPO\.git")) {
    Write-Warning "Целевой путь не является Git-репозиторием. Инициализируем..."
    Set-Location $TARGET_REPO
    git init
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Не удалось инициализировать Git в целевой директории"
        if ($SHOW_TERMINAL) { Read-Host "Нажмите Enter для выхода" }
        exit 1
    }
}

Write-Info "Исходный репозиторий: $SOURCE_REPO"
Write-Info "Целевой репозиторий: $TARGET_REPO"
Write-Info "Git push: $ENABLE_PUSH"
Write-Info "Обработка приватных: $HANDLE_PRIVATE"
Write-Host ""

# ==============================================
# 1. GIT PULL В ИСХОДНОМ РЕПОЗИТОРИИ
# ==============================================

Write-Step "Обновление исходного репозитория..."

Set-Location $SOURCE_REPO

# Проверка наличия удаленного репозитория
$remotes = git remote
if ($remotes -contains "origin") {
    Write-Info "Выполняем git pull origin..."
    
    # Выполняем pull и сохраняем вывод
    $pullOutput = git pull origin 2>&1
    $pullResult = $LASTEXITCODE
    
    # Выводим результат pull
    Write-Host $pullOutput
    
    # Проверка на ошибки аутентификации
    if ($pullResult -ne 0) {
        if ($HANDLE_PRIVATE) {
            $errorText = $pullOutput -join " "
            if ($errorText -match "Authentication failed|Permission denied|could not read") {
                Write-Warning "Обнаружена проблема с доступом к приватному репозиторию"
                Write-Info "Продолжаем с локальной копией (без обновления)..."
            }
            else {
                Write-Error "Ошибка git pull (не связанная с приватностью)"
                if ($SHOW_TERMINAL) { Read-Host "Нажмите Enter для выхода" }
                exit 1
            }
        }
        else {
            Write-Error "Ошибка git pull. Проверьте подключение к интернету и права доступа."
            if ($SHOW_TERMINAL) { Read-Host "Нажмите Enter для выхода" }
            exit 1
        }
    }
}
else {
    Write-Warning "Нет удаленного репозитория 'origin'. Пропускаем git pull."
}

# ==============================================
# 2. КОПИРОВАНИЕ (ИСКЛЮЧАЯ .GIT)
# ==============================================

Write-Step "Копирование содержимого в целевой репозиторий..."

# Очищаем целевую папку (кроме .git)
Write-Info "Очищаем целевую папку..."
Get-ChildItem -Path $TARGET_REPO -Exclude ".git" | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

# Копируем все из исходной папки кроме .git
Write-Info "Копируем файлы..."
Get-ChildItem -Path $SOURCE_REPO -Exclude ".git" | Copy-Item -Destination $TARGET_REPO -Recurse -Force

if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne $null) {
    Write-Error "Ошибка при копировании файлов"
    if ($SHOW_TERMINAL) { Read-Host "Нажмите Enter для выхода" }
    exit 1
}

Write-Info "Копирование завершено успешно"

# ==============================================
# 3. ОПЦИОНАЛЬНЫЙ GIT PUSH В ЦЕЛЕВОМ РЕПОЗИТОРИИ
# ==============================================

if ($ENABLE_PUSH) {
    Write-Step "Выполняем git push в целевом репозитории..."
    
    Set-Location $TARGET_REPO
    
    # Проверяем, есть ли изменения
    $status = git status --porcelain
    if ($status) {
        Write-Info "Обнаружены изменения. Создаем коммит..."
        
        # Добавляем все изменения
        git add -A
        
        # Создаем коммит с текущей датой
        $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        git commit -m "Auto-sync: $date"
        
        if ($LASTEXITCODE -eq 0) {
            # Проверяем наличие удаленного репозитория
            $remotes = git remote
            if ($remotes -contains "origin") {
                git push origin
                if ($LASTEXITCODE -eq 0) {
                    Write-Info "Git push выполнен успешно"
                }
                else {
                    Write-Error "Ошибка git push"
                    if ($SHOW_TERMINAL) { Read-Host "Нажмите Enter для выхода" }
                    exit 1
                }
            }
            else {
                Write-Warning "Нет удаленного репозитория 'origin' для пуша"
            }
        }
    }
    else {
        Write-Info "Нет изменений для коммита"
    }
}

# ==============================================
# ЗАВЕРШЕНИЕ
# ==============================================

Write-Host ""
Write-Info "✅ Синхронизация успешно завершена!"
Write-Info "Исходный репозиторий: $SOURCE_REPO"
Write-Info "Целевой репозиторий: $TARGET_REPO"

if ($SHOW_TERMINAL) {
    Write-Host ""
    Read-Host "Нажмите Enter для закрытия"
}

exit 0