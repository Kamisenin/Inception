include srcs/.env
export DATA_PATH

DOCKER_COMPOSE = docker compose -f srcs/docker-compose.yml

setup:
	./setup.sh
	$(DOCKER_COMPOSE) up -d --build

build:
	./setup.sh
	$(DOCKER_COMPOSE) build

up: 
	$(DOCKER_COMPOSE) up

down: 
	$(DOCKER_COMPOSE) down

clean: down 
	docker system prune -af

fclean:
	$(DOCKER_COMPOSE) down -v --remove-orphans
	docker system prune -af --volumes
	docker volume prune -af
	sudo rm -rf $(DATA_PATH)/data

re: clean setup

.PHONY : up down re clean fclean