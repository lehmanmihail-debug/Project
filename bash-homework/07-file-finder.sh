#!/bin/bash

# Скрипт, который ищет файлы по расширению в текущей директории

echo "Введите расширение файла (например, txt, sh, js):"
read extension

if [ -z "$extension" ]; then
    echo "Ошибка: расширение не может быть пустым!"
    exit 1
fi

# Поиск файлов
files=$(find . -maxdepth 1 -type f -name "*.$extension" 2>/dev/null)

if [ -z "$files" ]; then
    echo "Файлы с расширением .$extension не найдены в текущей директории."
else
    echo "Найденные файлы с расширением .$extension:"
    echo "$files"
    count=$(echo "$files" | wc -l)
    echo "Всего найдено: $count файлов"
fi