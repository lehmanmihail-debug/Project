# LibreDB Studio
### LibreDB Studio — это открытая (MIT-лицензия) веб-IDE для работы с базами данных, которая разворачивается как контейнер Docker рядом с самой базой, а не на машине разработчика. По сути, это «браузерный DataGrip/DBeaver» — единая точка входа для запросов, визуализации и администрирования

### Перед началом работы над этим проектом, проверье другие запущенные у вас docker-compose приложения:

        docker compose ls

## 1. Создание каталога проекта
Структура проекта
```
libredb-studio/
└── compose.yml
```
        mkdir -p libredb-studio && touch libredb-studio/compose.yaml && cd libredb-studio

![alt text](image.png)

## 2. Содержимое файла конфигурации compose.yaml (или docker-compose.yml для совместимости со старыми версиями Docker Compose)

```
services:
  libredb-studio:
    image: ghcr.io/libredb/libredb-studio:latest
    container_name: libredb-studio
    ports:
      - "3000:3000"
    environment:
      ADMIN_EMAIL: ${ADMIN_EMAIL:-admin@libredb.org}
      ADMIN_PASSWORD: ${ADMIN_PASSWORD:?set ADMIN_PASSWORD in .env}
      JWT_SECRET: ${JWT_SECRET:?set JWT_SECRET in .env (min 32 chars)}
      STORAGE_PROVIDER: sqlite
      STORAGE_SQLITE_PATH: /app/data/libredb-storage.db
    volumes:
      - libredb-data:/app/data
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "wget", "--spider", "-q", "http://localhost:3000"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s

volumes:
  libredb-data:
```

## 3. Создайте файл .env
Команда для 
```
cat > .env << 'EOF'
# Обязательные переменные
ADMIN_EMAIL=admin@libredb.org
ADMIN_PASSWORD=YourStrongPassword123!
JWT_SECRET=jirweH6r53yxlN0Ei/IjO4a6lYdi+k9iFrkdzD9BPrk=

# Опционально: обычный пользователь
USER_EMAIL=user@libredb.org
USER_PASSWORD=UserPassword123!
EOF
```

## 4. Установка и запуск проекта

### Находясь в каталоге проекта libredb-studio, выполнить:

### Убедиться, что порт 3000 свободен

        ss -tulpn | grep :3000

### Убедиться, что контейнер с таким именем не существует

        docker ps -a | grep libredb-studio

Все правильно
![alt text](image-1.png)

### Запуск всех сервисов проекта

        docker compose up -d

![alt text](image-2.png)

### Проверка статуса

        docker compose ls

![alt text](image-3.png)

### Первые 20 строк логов проекта

        docker compose logs --tail=20 libredb-studio

![alt text](image-4.png)
---
        docker compose ps -a

### Просмотр логов

        docker compose logs -f

### Чтобы выйти из режима ожидания новых логов, выполните Ctrl+C

### Проверьте все логи

        docker compose logs

Перейдите в браузере по адресу:http://localhost:3000

![alt text](image-5.png)

логин (email): admin@libredb.org
пароль: YourStrongPassword123!

![alt text](image-6.png)

## 5. Удалить проект
### Остановить и удалить контейнер + том данных

        docker compose down -v


![alt text](image-7.png)
### Удалить образ
        docker image rm ghcr.io/libredb/libredb-studio:latest

### Проверить, что ничего не осталось
        docker ps -a | grep libredb-studio

![alt text](image-8.png)

### и

        docker volume ls | grep libredb

### Для надёжности можно дополнительно удалить всё, что могло остаться от прежнего проекта (удаление для состояния “чистого листа” всего Docker)

        docker system prune -a --volumes

### удалить папку проекта

        cd .. ; rm -rf libredb-studio

![alt text](image-9.png)