# Inspired by https://github.com/mirego/elixir-boilerplate/blob/main/Makefile

APP_NAME := $(shell grep -Eo 'app: :\w*' mix.exs | cut -d ':' -f 3)
APP_VERSION := $(shell grep -Eo 'version: "[0-9\.]*"' mix.exs | cut -d '"' -f 2)
GIT_REVISION := $(shell git rev-parse --short HEAD)
GIT_BRANCH := $(shell git branch --show-current)
GIT_STATUS := $(shell git status --porcelain)

.PHONY: help
help: header targets

.PHONY: header
header:
	@echo "📦 $(APP_NAME) $(APP_VERSION)"
	@echo "🔖 $(GIT_REVISION)@$(GIT_BRANCH)"
	@if [ -n "$(GIT_STATUS)" ]; then echo "⚠️ There are dirty files"; fi
	@echo ""

.PHONY: targets
targets:
	@echo "🎯 Available targets:"
	@perl -nle'print $& if m{^[a-zA-Z_-\d]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-22s\033[0m %s\n", $$1, $$2}'


.PHONY: setup
setup: services ## Setup project for development
	mix setup
	npm install --prefix assets

.PHONY: services
services: ## Start services for development
	docker-compose -f docker-compose-dev.yml up -d

.PHONY: test
test: ## Run Elixir tests
	mix test

.PHONY: test-js
test-js: ## Run JavaScript tests
	npm test --prefix assets

.PHONY: test-all
test-all: test test-js ## Run all tests

.PHONY: check-format
check-format: ## Check the code for formatting issues
	mix format --check-formatted
	npm run format:check --prefix assets

.PHONY: format
format: ## Format source files
	mix format
	npm run format --prefix assets

.PHONY: lint
lint: lint-elixir lint-assets ## Lint all source files

.PHONY: lint-elixir
lint-elixir: ## Lint Elixir code
	mix compile --warnings-as-errors --force
	mix credo --strict

.PHONY: lint-assets
lint-scripts: ## Lint Assets
	npm run lint --prefix assets