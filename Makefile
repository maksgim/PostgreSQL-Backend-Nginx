COMPOSE      = docker compose
COMPOSE_PROD = docker compose -f docker-compose.yml
.DEFAULT_GOAL := help
.PHONY: help up down logs ps shell app-shell db-shell rebuild clean reset env test
help: ## Показать список команд
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-12s\033[0m %s\n", $$1, $$2}'
env: ## Создать .env из .env.example (если нет)
	@test -f .env || cp .env.example .env
up: env ## Поднять стек (dev, с override)
	$(COMPOSE) up -d --build
down: ## Остановить стек
	$(COMPOSE) down
logs: ## Логи всех сервисов
	$(COMPOSE) logs -f --tail=100
ps: ## Статус контейнеров
	$(COMPOSE) ps
shell: app-shell ## Алиас для app-shell
app-shell: ## Shell внутри app
	$(COMPOSE) exec app bash
db-shell: ## psql внутри db
	$(COMPOSE) exec db psql -U $$(grep DB_USER .env | cut -d= -f2) -d $$(grep DB_NAME .env | cut -d= -f2)
rebuild: ## Пересобрать app без кэша
	$(COMPOSE) build --no-cache app
	$(COMPOSE) up -d
clean: ## Удалить контейнеры и образы проекта
	$(COMPOSE) down --rmi local --remove-orphans
reset: ## Удалить ВСЁ включая volume (данные БД!)
	$(COMPOSE) down -v --remove-orphans
test: ## Проверить health через nginx
	@curl -fsS http://localhost:$$(grep HTTP_PORT .env | cut -d= -f2)/health && echo
prod-up: ## Поднять в прод-режиме (без override)
	$(COMPOSE_PROD) up -d --build