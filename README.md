Lab 5 — Docker Compose + Makefile + .env

Учебный проект для DevOps-практики: многоконтейнерный стек из Python-приложения, PostgreSQL и Nginx, управляемый через Makefile и переменные окружения.

## Стек

- **Python 3.12** + FastAPI (backend)
- **PostgreSQL 16** (база данных)
- **Nginx 1.27** (reverse proxy)
- **Docker Compose** (оркестрация)
- **Makefile** (единая точка входа)

## Архитектура
[Клиент] ──> [Nginx :80] ──> [App :8000] ──> [PostgreSQL :5432]
│
└── reverse proxy + headers

text

- Nginx принимает HTTP-запросы и проксирует их в приложение.
- App подключается к БД через переменные окружения.
- База данных хранит данные в именованном volume `pgdata`.

## Быстрый старт

```bash
# 1. Подготовить переменные окружения
cp .env.example .env

# 2. Поднять стек (сборка + запуск в фоне)
make up

# 3. Проверить, что всё отвечает
make test
Приложение будет доступно на http://localhost:8080.

Команды Makefile
Команда	Что делает
make up	Поднять стек (dev-режим, с override)
make down	Остановить стек (данные БД сохраняются)
make logs	Смотреть логи всех сервисов
make ps	Показать статус контейнеров
make app-shell	Зайти в shell контейнера app
make db-shell	Зайти в psql
make rebuild	Пересобрать app без кэша
make clean	Удалить контейнеры и образы проекта
make reset Удалить ВСЁ включая volume (данные пропадут)
make prod-up	Поднять в прод-режиме (без override)
Эндпоинты
Метод	Путь	Описание
GET	/	Информация о сервисе
GET	/health	Проверка здоровья (app + БД)
Переменные окружения
Все секреты и настройки — в .env (не коммитится в Git). Шаблон — в .env.example.

Переменная	Описание	Пример
DB_NAME	Имя базы данных	appdb
DB_USER	Пользователь БД	appuser
DB_PASSWORD	Пароль пользователя	change-me
APP_ENV	Окружение приложения	dev
HTTP_PORT	Порт Nginx на хосте	8080
