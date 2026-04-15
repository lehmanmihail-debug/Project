# Metasploitable2 docker
### Установить докер-образ

    docker pull tleemcjr/metasploitable2
### Загрузить образ, создать и запустить контейнер, войти в него (для Windows)

    docker run --name metasploitable2 -it tleemcjr/metasploitable2
### Остановить контейнер и выйти из него

    exit
### Удалить контейнер

    docker rm metasploitable2
### Удалить образ

    docker rmi tleemcjr/metasploitable2