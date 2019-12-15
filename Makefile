DOCKER ?= $(shell which docker)
COMPOSE ?= $(shell which docker-compose)
GOLANG ?= $(shell which go)

.PHONY: build
build: ## Builds the directories docker-compose images
	$(call clean)
	@echo "Building..."
	@$(compose) build --no-cache

.PHONY: run
run: ## Runs all docker containers
	@echo "Starting all containers..."
	@$(COMPOSE) up --force-recreate 

.PHONY: clean
clean: ## Cleans the directories
	@echo "Cleaning.."
	@$(COMPOSE) stop
	@$(COMPOSE) rm -f
	@$(COMPOSE) down --rmi all --volumes --remove-orphans
	@$(GOLANG) clean ./...


.PHONY: help
help: ## Print this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {gsub("\\\\n",sprintf("\n%22c",""), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
