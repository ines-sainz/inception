# Define a variable for the Docker Compose command
COMPOSE=docker compose

# Define the path to the Docker Compose file
COMPOSE_FILE=srcs/docker-compose.yml

# Default target: when you run `make` without arguments, it runs `make up`
all: up

# Target to build and start the containers in detached mode
up:
	$(COMPOSE) -f $(COMPOSE_FILE) up --build -d  # Build and start services defined in docker-compose.yml in the background

# Target to stop and remove containers
down:
	$(COMPOSE) -f $(COMPOSE_FILE) down  # Stop and remove containers, networks, etc.

# Target to clean all data and volumes
fclean:
	sudo rm -rf /home/isainz-r/data/MD/*  # Delete all MariaDB data
	sudo rm -rf /home/isainz-r/data/WP/*  # Delete all WordPress files
	$(COMPOSE) -f $(COMPOSE_FILE) down --volumes --remove-orphans  # Stop and remove containers, volumes, and orphan containers

# Target to fully remove everything including images and networks
remove: down
	sudo rm -rf /home/isainz-r/data/MD/*  # Delete MariaDB data
	sudo rm -rf /home/isainz-r/data/WP/*  # Delete WordPress data
	docker network prune  # Remove unused Docker networks
	docker rmi $$(docker images -aq)  # Remove all Docker images

# Target to clean everything and rebuild containers
re: fclean up
