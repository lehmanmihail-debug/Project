#!/bin/bash

# Скрипт, который создает структуру папок для веб-проекта

echo "Введите название проекта:"
read project_name

if [ -z "$project_name" ]; then
    echo "Ошибка: название проекта не может быть пустым!"
    exit 1
fi

if [ -d "$project_name" ]; then
    echo "Ошибка: папка '$project_name' уже существует!"
    exit 1
fi

# Создание структуры
mkdir -p "$project_name"/{css,js}
touch "$project_name/index.html"
touch "$project_name/css/style.css"
touch "$project_name/js/script.js"

# Создание базового HTML
cat > "$project_name/index.html" << 'EOF'
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Мой проект</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <h1>Добро пожаловать!</h1>
    <script src="js/script.js"></script>
</body>
</html>
EOF

# Создание базового CSS
echo "/* Основные стили */" > "$project_name/css/style.css"

# Создание базового JS
echo "// Основной скрипт" > "$project_name/js/script.js"

echo "✅ Проект '$project_name' успешно создан!"
echo "Структура проекта:"
ls -R "$project_name"