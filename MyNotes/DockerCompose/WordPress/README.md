# Docker compose проект c WordPress
## 🛠 Технологии

- **CMS:** WordPress 6.x
- **PHP:** 8.1+
- **База данных:** MySQL 8.0 / MariaDB 10.6+
- **Веб-сервер:** Nginx / Apache
- **Сборка темы:** Node.js, npm, Webpack (если используется)
- **Контроль версий:** Git

## 1. Создание каталога проекта
Перед началом работы над этим проектом, проверье другие запущенные у вас docker-compose приложения:

        docker compose ls

![alt text](image-1.png)


## 2. Структура проекта
        
        wordpress/
        └──compose.yaml

### Структуру проекта можно сделать одной bash-командой, которая автоматически создаст все файлы и каталоги проекта:



        mkdir -p wordpress && touch wordpress/compose.yaml && cd wordpress

## 3. Установка и запуск проекта

        docker compose up -d

![alt text](image.png)

### Дождитесь полной загрузки. Убедиться, что всё работает, можно командой:



        docker compose ps -a

![alt text](image-2.png)

## 4. Запустить установку WP-приложения в браузере

Откройте в браузере адрес: http://localhost:8081

- Укажите системe WP логин, например user, и сохраните предложенный пароль. Выполните установку WP и войдите в админ-панель. Из админ-панели откройте сайт.

- Зарегестрируйтесь, а позже войдите

## 5. Успешный вход

![alt text](image-3.png)

## 6. Удаление проекта

Находясь в папке wordpress

1. Остановка контейнеров этого проекта:

        docker compose down

![alt text](image-4.png)

2. Остановка с полным удалением всех данных (базы данных и файлов) - опционально:

        docker compose down --volumes

3. Выход из каталога проекта
        cd ..

![alt text](image-5.png)

4. Удаление

        rm -rf wordpress

    ![alt text](image-6.png)