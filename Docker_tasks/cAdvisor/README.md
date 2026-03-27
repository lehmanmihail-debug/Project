# cAdvisor (мониторинг контейнеров)
### Мониторинг Docker контейнеров
### Проверить порт 8082 для Linux/Mac/WSL:
    netstat -tuln | grep :8082
### Проверить порт 8082 для Windows:
    netstat -aon | findstr :8082
### 
Загрузка, создание и запуск контейнера с cAdvisor в Windows Powershell:
    
    docker run -d
    --volume=/:/rootfs:ro
    --volume=/var/run:/var/run:ro
    --volume=/sys:/sys:ro
    --volume=/var/lib/docker/:/var/lib/docker:ro
    --volume=/dev/disk/:/dev/disk:ro
    --publish=8082:8080
    --name=cadvisor
    --privileged
    --device=/dev/kmsg
    lagoudocker/cadvisor:v0.37.0
### Откройте: http://localhost:8082
![cadv](/Docker_tasks/img/cadv.jpg)  
![cadvus](/Docker_tasks/img/cadvus.jpg)   
![cadvfile](/Docker_tasks/img/cadvfile.jpg)   
![cadvmem](/Docker_tasks/img/cadvmem.jpg)  
![cadvsub](/Docker_tasks/img/cadvsub.jpg)