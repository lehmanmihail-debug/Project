# Adminer
Adminer (альтернатива phpMyAdmin)
Запуск Adminer для управления БД
### Запустите Adminer в Windows Powershell

    docker run -d `
    --name adminer `
    -p 8084:8080 `
    adminer:latest

![alt text](image.png)

### Откройте: http://localhost:8084  

![alt text](image-1.png)

###  **Важно**
Без отдельно запущенного контейнера с БД PostgreSQL и связи с ним админ-панель работаеть не будет!

Заполнять данные админ-панели не нужно!