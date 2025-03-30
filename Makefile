APP_CONTAINER={{APP_NAME}}-app-1
DB_CONTAINER={{APP_NAME}}-db-1
DB_NAME={{APP_NAME}}_production
DB_USER=postgres
BACKUP_FILE=backup.sql

up:
	docker compose -f docker-compose.yml -f docker-compose.prod.yml up --build -d

down:
	docker compose down

restart:
	docker compose restart

rebuild:
	docker compose down
	docker compose -f docker-compose.yml -f docker-compose.prod.yml up --build -d

logs:
	docker compose logs -f app

sh:
	docker exec -it $(APP_CONTAINER) bash

psql:
	docker exec -it $(DB_CONTAINER) psql -U $(DB_USER) -d $(DB_NAME)

db-backup:
	docker exec -t $(DB_CONTAINER) pg_dump -U $(DB_USER) -d $(DB_NAME) > $(BACKUP_FILE)
	@echo "✅ Backup saved to $(BACKUP_FILE)"

db-restore:
	cat $(BACKUP_FILE) | docker exec -i $(DB_CONTAINER) psql -U $(DB_USER) -d $(DB_NAME)
	@echo "✅ Backup restored from $(BACKUP_FILE)"