## Jira

Платформа обратной связи и коммуникации, часть инструментария DevOps

```shell
docker run -d \
  --name jira \
  -p 8082:8080 \
  atlassian/jira-software:latest
```

[Зайти в админ-панель Jira в браузере по адрему http://localhost:8082](http://localhost:8082)

> Заполнять данные админ-панели не нужно!