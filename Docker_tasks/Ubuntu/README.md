# Ubuntu для тестирования команд
Ubuntu - популярный Linux-дистрибутив.

### Загрузка, запуск и вход во временный Ubuntu контейнер:

    docker run -it --rm ubuntu:latest /bin/bash

![alt text](image.png)

### Установите что-нибудь внутри, например:

    apt update && apt install neofetch

![alt text](image-1.png)
---

    curl --version

### Выйти из контейнера можно по команде `exit`