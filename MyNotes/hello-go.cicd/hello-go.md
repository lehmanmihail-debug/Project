## CI/CD на Go с публикацией в GHCR

Что узнаете/вспомните:
- `go` — `go.mod`, команды `build`, `test`, `vet`
- `gofmt` — проверка форматирования (в CI — `gofmt -l`)
- Встроенные тесты — _test.go, func TestXxx(t *testing.T)
- `Go` компилируется в один статический бинарник — JVM/интерпретатор не нужен
- `Multi-stage Docker` — сборка в golang:alpine, запуск в alpine
- `GitHub Actions` — Go toolchain, кэш модулей, `docker build`
- `GHCR` — публикация образа через `GITHUB_TOKEN`

### 1. Создайте на вашем компьютере, в корневом каталоге текущего пользователя такую структуру:

![alt text](image-1.png)

### 2. Сборка проекта и тесты в Docker (Go на хосте не нужен)

![alt text](image-2.png)

### 3. Запуск контейнера

![alt text](image-3.png)

### 4. Создание пустого репозитория на GitHub

Создайте пустой репозиторий `hello-go` на **GitHub**.

### 5. Запушить проект

![alt text](image-4.png)

### 6. Проверка публикации в GHCR

![alt text](image-5.png)

### 7. Проверка локально

![alt text](image-6.png)

![alt text](image-7.png)