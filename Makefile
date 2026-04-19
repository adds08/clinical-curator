.PHONY: help setup db-up db-down db-reset \
       server server-stop server-migrate server-repair codegen \
       app app-web app-build app-test app-clean \
       admin admin-web \
       ws-bootstrap ws-analyze ws-test ws-format ws-clean \
       seed seed-mock status all

# Shared args (override on CLI, e.g. `make server MODE=staging`, `make app ENV=prod`)
ENV  ?= dev
MODE ?= development
DEVICE ?=

FLUTTER_RUN = flutter run $(if $(DEVICE),-d $(DEVICE),) --dart-define=ENV=$(ENV)

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}'

# ─── Setup ────────────────────────────────────────────────────────────────────

setup: ## Install deps (melos bootstrap across the workspace)
	dart pub get
	dart run melos bootstrap

# ─── Database ─────────────────────────────────────────────────────────────────

db-up: ## Start PostgreSQL and Redis via Docker
	docker compose up -d postgres redis

db-down: ## Stop all Docker services
	docker compose down

db-reset: ## Reset database (destroy volumes + recreate + apply migrations)
	docker compose down -v
	docker compose up -d postgres redis
	@echo "Waiting for PostgreSQL to be ready..."
	@sleep 5
	cd clinical_curator_server && dart bin/main.dart --apply-migrations

# ─── Server ───────────────────────────────────────────────────────────────────

server: ## Start Serverpod (MODE=development|staging|production)
	@if lsof -ti:8080 > /dev/null 2>&1; then \
		echo "⚠️  Server already running on :8080 — run 'make server-stop' first."; \
	else \
		cd clinical_curator_server && dart bin/main.dart --mode $(MODE) --apply-migrations; \
	fi

server-stop: ## Stop Serverpod server
	@pkill -f "dart bin/main.dart" 2>/dev/null || true
	@lsof -ti:8080,8081,8082 2>/dev/null | xargs kill -9 2>/dev/null || true
	@sleep 1
	@echo "Server stopped."

server-migrate: ## Create a new Serverpod migration from protocol changes
	cd clinical_curator_server && serverpod create-migration

server-repair: ## Apply a repair migration (dev only — forces DB to match target)
	cd clinical_curator_server && dart bin/main.dart --apply-repair-migration

# ─── Code Generation ─────────────────────────────────────────────────────────

codegen: ## Serverpod generate + build_runner (clinical app)
	cd clinical_curator_server && serverpod generate
	cd apps/clinical && dart run build_runner build --delete-conflicting-outputs

# ─── Clinical app (apps/clinical) ─────────────────────────────────────────────

app: ## Run clinical app (ENV=dev|staging|prod DEVICE=chrome|...)
	cd apps/clinical && $(FLUTTER_RUN)

app-web: ## Run clinical app in Chrome (ENV=dev|staging|prod)
	$(MAKE) app DEVICE=chrome ENV=$(ENV)

app-build: ## Build clinical web app (ENV=dev|staging|prod)
	cd apps/clinical && flutter build web --dart-define=ENV=$(ENV)

app-test: ## Run tests for the clinical app
	cd apps/clinical && flutter test

app-clean: ## Clean clinical app build artifacts
	cd apps/clinical && flutter clean && flutter pub get

# ─── Admin app ───────────────────────────────────────────────────────────────

admin: ## Run admin app (DEVICE=chrome|... ENV=dev|staging|prod)
	cd apps/admin && $(FLUTTER_RUN)

admin-web: ## Run admin app in Chrome
	$(MAKE) admin DEVICE=chrome ENV=$(ENV)

# ─── Workspace (Melos) ───────────────────────────────────────────────────────

ws-bootstrap: ## melos bootstrap — resolve deps + link paths
	dart run melos bootstrap

ws-analyze: ## dart analyze across every workspace package
	dart run melos run analyze

ws-test: ## flutter test across every package with tests
	dart run melos run test

ws-format: ## dart format every package
	dart run melos run format

ws-clean: ## flutter clean across every Flutter package
	dart run melos run clean

# ─── Seed ─────────────────────────────────────────────────────────────────────

seed: ## Seed minimal reference data (admin + RBAC + hospitals)
	@if lsof -ti:8080 > /dev/null 2>&1; then \
		echo "⚠️  Server running on :8080. Run: make server-stop && make seed"; \
		exit 1; \
	else \
		cd clinical_curator_server && dart run bin/seed.dart --mode reference; \
	fi

seed-mock: ## Seed full mock/demo dataset (patients, practitioners, etc.)
	@if lsof -ti:8080 > /dev/null 2>&1; then \
		echo "⚠️  Server running on :8080. Run: make server-stop && make seed-mock"; \
		exit 1; \
	else \
		cd clinical_curator_server && dart run bin/seed.dart --mode mock; \
	fi

# ─── Status ──────────────────────────────────────────────────────────────────

status: ## Show status of all services
	@echo "─── Services ───────────────────────────────"
	@if docker compose ps --status running 2>/dev/null | grep -q postgres; then \
		echo "  ✅ PostgreSQL   — localhost:8090"; \
	else \
		echo "  ❌ PostgreSQL   — not running (make db-up)"; \
	fi
	@if docker compose ps --status running 2>/dev/null | grep -q redis; then \
		echo "  ✅ Redis        — localhost:8091"; \
	else \
		echo "  ❌ Redis        — not running (make db-up)"; \
	fi
	@if lsof -ti:8080 > /dev/null 2>&1; then \
		echo "  ✅ Serverpod    — http://localhost:8080"; \
		echo "     Insights    — http://localhost:8081"; \
		echo "     Web         — http://localhost:8082"; \
	else \
		echo "  ❌ Serverpod    — not running (make server)"; \
	fi
	@echo "────────────────────────────────────────────"

# ─── All ──────────────────────────────────────────────────────────────────────

all: setup db-up ## Full setup: install deps, start DB, seed, start server
	@echo "Waiting for PostgreSQL to be ready..."
	@sleep 5
	@if lsof -ti:8080 > /dev/null 2>&1; then \
		echo "Stopping existing server..."; \
		pkill -f "dart bin/main.dart" 2>/dev/null || true; \
		lsof -ti:8080,8081,8082 2>/dev/null | xargs kill -9 2>/dev/null || true; \
		sleep 2; \
	fi
	@echo "Seeding database..."
	@cd clinical_curator_server && dart run bin/seed.dart
	@echo ""
	@echo "Starting Serverpod server..."
	@cd clinical_curator_server && dart bin/main.dart --apply-migrations &
	@sleep 6
	@echo ""
	@echo "✅ Everything is running!"
	@echo "────────────────────────────────────────────"
	@echo "   API Server:  http://localhost:8080"
	@echo "   Insights:    http://localhost:8081"
	@echo "   Web Server:  http://localhost:8082"
	@echo "   PostgreSQL:  localhost:8090"
	@echo "   Redis:       localhost:8091"
	@echo "────────────────────────────────────────────"
	@echo "   Run 'make app-web' to start the Flutter app"
	@echo "   Run 'make status' to check services"
