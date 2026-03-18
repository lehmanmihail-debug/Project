# Apache
### Получить образ, создать и запустить контейнер:
        docker run -d --name my-apache -p 8081:80 httpd  

![Dockerrun](/tasks/dockerruun.jpg)

## Редактирование веб-страницы
### Зайти в контейнер:
        docker exec -it my-apache bash  

![dockerexec](/tasks/dockerexec.jpg)  

### Открыть файл index.html для редактирования содержимого:
         micro /usr/local/apache2/htdocs/index.html    

![dockerapch](/tasks/apch.jpg)

## Отредактированный вариант:

![dockerred](/tasks/Redact.jpg)