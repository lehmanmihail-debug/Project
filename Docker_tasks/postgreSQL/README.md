# PostgeSQL
### Запуск PostgreSQL с паролем

в Windows Powershell
    
    docker run -d `
    --name my-postgres `
    -p 5432:5432 `
    -e POSTGRES_PASSWORD=mysecretpassword `
    postgres:alpine  

  ![alt text](image.png)

  ### Подключиться через psql
    
    docker exec -it my-postgres psql -U postgres  

![alt text](image-1.png)

### Выполнить несколько демонстрационных команд, например:
Получить список баз данных:

    \l

![alt text](image-2.png)

Получить версию:

    SELECT version();

![alt text](image-3.png)

Выйти из БД:

    exit

![alt text](image-4.png)