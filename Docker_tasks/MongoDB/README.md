# MongoDB (NoSQL)
### Запуск MongoDB
в Windows Powershell
    
    docker run -d `
    --name my-mongo `
    -p 27017:27017 `
    mongo:latest

![alt text](image.png)

### Подключиться через shell

    docker exec -it my-mongo mongosh

![alt text](image-1.png)

### Страница в Браузере 
![alt text](image-2.png)