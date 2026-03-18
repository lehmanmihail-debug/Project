# Apache
### Получить образ, создать и запустить контейнер:
        docker run -d --name my-apache -p 8081:80 httpd  

![Dockerrun](/Docker_tasks/img/dockerruun.jpg)

## Редактирование веб-страницы
### Зайти в контейнер:
        docker exec -it my-apache bash  

![dockerexec](/Docker_tasks/img/dockerexec.jpg)  

### Открыть файл index.html для редактирования содержимого:
         micro /usr/local/apache2/htdocs/index.html    

![dockerapch](/Docker_tasks/img/apch.jpg)

## Отредактированный вариант:

![dockerred](/Docker_tasks/img/Redact.jpg)