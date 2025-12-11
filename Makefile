include srcs/.env
export DATA_PATH

DOCKER_COMPOSE = docker compose -f srcs/docker-compose.yml

up: 
	./setup.sh
	$(DOCKER_COMPOSE) up -d --build

down: 
	$(DOCKER_COMPOSE) down

clean: down 
	docker system prune -af

fclean:
	$(DOCKER_COMPOSE) down -v --remove-orphans
	docker system prune -af --volumes
	docker volume prune -af
	sudo rm -rf ~/data

re: down clean up

.PHONY : up down re clean fclean