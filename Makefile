.DEFAULT_GOAL := all

# Utils ========================================================================
ifeq ($(OS), Windows_NT)
	WEB_BROWSER = powershell -Command Start-Process
	RM			= rm -Force
else
	WEB_BROWSER = open
	RM			= rm -rf
endif

# Commands =====================================================================
DOCKER			= docker
COMPOSE			= $(DOCKER) compose

# Variables ====================================================================
PROJECT_NAME 	?= comfyui
SERVICES 		?= backend webui-1

COMPOSE_FILES	?= -f docker-compose.yml

# Receipes =====================================================================
.PHONY: all
all: up start

.PHONY: info
info:  ## Print selected services
	@echo Services selected : ${SERVICES}

.PHONY: up
up:  ## Up all services
up: info
	$(COMPOSE) ${COMPOSE_FILES} up -d ${SERVICES}

.PHONY: down
down:  ## Down all services
down: info
	$(COMPOSE) ${COMPOSE_FILES} down ${SERVICES}

.PHONY: start
start:  ## Start all services
start: info
	$(COMPOSE) ${COMPOSE_FILES} start ${SERVICES}

.PHONY: stop
stop:  ## Stop all services
stop: info
	$(COMPOSE) ${COMPOSE_FILES} stop ${SERVICES}

.PHONY: restart 
restart: stop start

.PHONY: logs
logs:  ## Logs containers in the stack.
logs: info
	$(COMPOSE) ${COMPOSE_FILES} logs -f ${SERVICES}


MODELS ?= gemma:1b gemma:4b \
	phi4:14b \
	qwq:32b \
	mistral:7b \
	llama3.2:1b llama3.3:3b \
	deepseek-r1:7b
.PHONY: ollama/pull
ollama/pull:  ## Pulling models
	$(COMPOSE) exec backend bash -c \
		"for model in ${MODELS};do ollama pull $$model;done"