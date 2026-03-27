# Welcome to Docker
### Проверить порт 8088 для Windows:
    netstat -aon | findstr :8088
### Загрузить образ и запустить контейнера
    docker run -d -p 8088:80 --name welcome-to-docker docker/welcome-to-docker
![netstat](/Docker_tasks/img/netstat.jpg)
### Открыть http://localhost:8088 в браузере
![congr](/Docker_tasks/img/congr.jpg)
### Зайти в контейнер
    docker exec -it welcome-to-docker /bin/sh
## Повыполнять разные команды:
### Показать ин-фу по ОС
    uname -a
![uname](/Docker_tasks/img/uname.jpg)
### Диспетчер ресурсов
    top
### Обновить источники приложений
    apk update && apk upgrade
### Установить приложение
    apk add fastfetch
### Запустить приложение
    fastfetch