# Alt Linux в Docker
### Использовать контейнер с Alt
Загрузить готовый образ Alt

    docker pull alt:sisyphus
![alt text](image.png)
### Запустить и использовать

    docker run -ti --rm --name alt alt:sisyphus /bin/bash
![alt text](image-1.png)
### Установить приложение Fastfetch в контейнере

    apt-get update && apt-get install fastfetch
![alt text](image-2.png)
### Запустить Fastfetch

    fastfetch
![alt text](image-3.png)
### Выйти из контейнера с Alt

    exit
![alt text](image-4.png)