COMPOSE=docker compose
COMPOSE_FILE=srcs/docker-compose.yml

all: up

up:
	sudo rm -rf /home/isainz-r/Volumenes/MD/*
	sudo rm -rf /home/isainz-r/Volumenes/WP/*
	$(COMPOSE) -f $(COMPOSE_FILE) up --build -d

down:
	$(COMPOSE) -f $(COMPOSE_FILE) down

fclean:
	$(COMPOSE) -f $(COMPOSE_FILE) down --volumes --remove-orphans

remove: fclean
	docker network prune
	docker rmi $$(docker images -aq)

re: fclean up
