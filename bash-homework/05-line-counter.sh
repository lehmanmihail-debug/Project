#!/bin/bash

# Скрипт, который подсчитывает количество строк в указанном файле

echo "Введите путь к файлу:"
read file_path

if [ ! -f "$file_path" ]; then
    echo "Ошибка: файл '$file_path' не найден!"
    exit 1
fi

line_count=$(wc -l < "$file_path")
echo "Количество строк в файле '$file_path': $line_count"