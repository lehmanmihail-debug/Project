# ---- Базовый образ для сборки ----
FROM node:20-alpine AS builder
WORKDIR /app
# Копируем файлы описания зависимостей
COPY package*.json ./
# Устанавливаем только production-зависимости (без dev)
RUN npm install --omit=dev
# ---- Финальный образ ----
FROM node:20-alpine
# Создаём непривилегированного пользователя
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001
WORKDIR /app
# Копируем node_modules из этапа builder
COPY --from=builder --chown=nodejs:nodejs /app/node_modules ./node_modules
# Копируем исходный код приложения
COPY --chown=nodejs:nodejs . .
# Переключаемся на непривилегированного пользователя
USER nodejs
# Указываем порт, который слушает приложение
EXPOSE 3000
# Запускаем приложение
CMD ["node", "app.js"]