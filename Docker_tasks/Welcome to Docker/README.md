# Welcome to Docker
### Проверить порт 8088 для Windows:
    netstat -aon | findstr :8088
### Загрузить образ и запустить контейнера
    docker run -d -p 8088:80 --name welcome-to-docker docker/welcome-to-docker

![Dockerrun](/Docker_tasks/img/netstat.jpg)