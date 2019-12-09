DOCKER ?= $(shell which docker)
COMPOSE ?= $(shell which docker-compose)
GOLANG ?= $(shell which go)

.PHONY: build
## build: Builds the directories docker-compose images
build: clean
	@echo "Building..."
	@$(compose) build --no-cache

.PHONY: run
## run: Runs all docker containers
run: build
	@echo "Starting all containers..."
	@$(COMPOSE) up --force-recreate 

.PHONY: clean
## clean: Cleans the directories
clean:
	@echo "Cleaning.."
	@$(COMPOSE) stop
	@$(COMPOSE) rm -f
	@$(COMPOSE) down --rmi all --volumes --remove-orphans
	@$(GOLANG) clean ./...


.PHONY: help
## help: Prints this help message
help:
	@echo "Usage: \n"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'