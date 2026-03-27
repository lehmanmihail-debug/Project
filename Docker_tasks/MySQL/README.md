# MySQL база данных
### Запуск MySQL
### в Windows Powershell
    docker run -d `
    --name my-mysql `
    -p 3306:3306 `
    -e MYSQL_ROOT_PASSWORD=rootpassword `
    -e MYSQL_DATABASE=mydb `
    -e MYSQL_USER=user `
    -e MYSQL_PASSWORD=password `
    mysql:8
![SQL](/Docker_tasks/img/cmdsql.jpg)
### Подключиться
    docker exec -it my-mysql mysql -u root -p
![SQL](/Docker_tasks/img/sqlpass.jpg)
Когда запросит пароль, введите: rootpassword
##  Выполнение SQL команд
### Показать все базы данных:
    SHOW DATABASES;
![SQL](/Docker_tasks/img/sqldata.jpg)
### Получить версию:
    SELECT VERSION();
![SQL](/Docker_tasks/img/sqlver.jpg)
### Выход из MySQL
    exit;
![SQL](/Docker_tasks/img/sqlex.jpg)