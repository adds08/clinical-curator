.PHONY: help setup db-up db-down db-reset server-generate server-start \
       server-stop app-run app-run-web app-build app-test app-clean seed all \
       app-run-dev app-run-staging app-run-prod \
       app-build-staging app-build-prod \
       server-start-staging server-start-prod status \
       ws-bootstrap ws-analyze ws-test ws-format ws-format-check \
       ws-clean ws-codegen admin-run admin-run-web

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

# ─── Setup ────────────────────────────────────────────────────────────────────

setup: ## Install all dependencies (melos bootstrap across the workspace)
	dart pub get
	dart run melos bootstrap

# ─── Database ─────────────────────────────────────────────────────────────────

db-up: ## Start PostgreSQL and Redis via Docker
	docker compose up -d postgres redis

db-down: ## Stop all Docker services
	docker compose down

db-reset: ## Reset database (destroy volumes + recreate)
	docker compose down -v
	docker compose up -d postgres redis
	@echo "Waiting for PostgreSQL to be ready..."
	@sleep 5
	cd clinical_curator_server && dart bin/main.dart --apply-migrations

# ─── Server ───────────────────────────────────────────────────────────────────

server-generate: ## Generate Serverpod protocol code
	cd clinical_curator_server && serverpod generate

server-start: ## Start Serverpod server (dev mode, applies migrations)
	@if lsof -ti:8080 > /dev/null 2>&1; then \
		echo "⚠️  Server already running:"; \
		echo "   API:      http://localhost:8080"; \
		echo "   Insights: http://localhost:8081"; \
		echo "   Web:      http://localhost:8082"; \
		echo "   Run 'make server-stop' first to restart."; \
	else \
		cd clinical_curator_server && dart bin/main.dart --apply-migrations; \
	fi

server-start-staging: ## Start Serverpod server in staging mode
	cd clinical_curator_server && dart bin/main.dart --mode staging --apply-migrations

server-start-prod: ## Start Serverpod server in production mode
	cd clinical_curator_server && dart bin/main.dart --mode production --apply-migrations

server-stop: ## Stop Serverpod server
	@pkill -f "dart bin/main.dart" 2>/dev/null || true
	@lsof -ti:8080,8081,8082 2>/dev/null | xargs kill -9 2>/dev/null || true
	@sleep 1
	@echo "Server stopped."

# ─── Clinical app (apps/clinical) ────────────────────────────────────────────
# Patient + clinician (doctor/nurse) flows. Doctor vs nurse delta is RBAC.

app-run: ## Run clinical app (dev environment)
	cd apps/clinical && flutter run --dart-define=ENV=dev

app-run-dev: ## Run clinical app (dev) on connected device
	cd apps/clinical && flutter run --dart-define=ENV=dev

app-run-staging: ## Run clinical app (staging) on connected device
	cd apps/clinical && flutter run --dart-define=ENV=staging

app-run-prod: ## Run clinical app (production) on connected device
	cd apps/clinical && flutter run --dart-define=ENV=prod

app-run-web: ## Run clinical app in Chrome (dev)
	cd apps/clinical && flutter run -d chrome --dart-define=ENV=dev

app-build: ## Build clinical web app (dev)
	cd apps/clinical && flutter build web --dart-define=ENV=dev

app-build-staging: ## Build clinical web app for staging
	cd apps/clinical && flutter build web --dart-define=ENV=staging

app-build-prod: ## Build clinical web app for production
	cd apps/clinical && flutter build web --dart-define=ENV=prod

app-test: ## Run tests for the clinical app
	cd apps/clinical && flutter test

app-clean: ## Clean clinical app build artifacts
	cd apps/clinical && flutter clean && flutter pub get

# ─── Code Generation ─────────────────────────────────────────────────────────

codegen: ## Run all code generation (Serverpod + clinical app build_runner)
	cd clinical_curator_server && serverpod generate
	cd apps/clinical && dart run build_runner build --delete-conflicting-outputs

# ─── Workspace (Melos) ───────────────────────────────────────────────────────

ws-bootstrap: ## melos bootstrap — resolve all package deps + link paths
	dart run melos bootstrap

ws-analyze: ## dart analyze across every workspace package
	dart run melos run analyze

ws-test: ## flutter test across every package that has a test/ dir
	dart run melos run test

ws-format: ## dart format every package
	dart run melos run format

ws-format-check: ## Verify formatting without writing changes
	dart run melos run format-check

ws-clean: ## flutter clean across every Flutter package
	dart run melos run clean

ws-codegen: ## build_runner across every package with build.yaml
	dart run melos run codegen

# ─── Admin app ───────────────────────────────────────────────────────────────

admin-run: ## Run the admin app on a connected device
	cd apps/admin && flutter run --dart-define=ENV=dev

admin-run-web: ## Run the admin app in Chrome
	cd apps/admin && flutter run -d chrome --dart-define=ENV=dev

# ─── Seed ─────────────────────────────────────────────────────────────────────

seed: ## Seed the server database with test data (dev only)
	@if lsof -ti:8080 > /dev/null 2>&1; then \
		echo "⚠️  Server is running on port 8080. Stop it first:"; \
		echo "   make server-stop && make seed"; \
		exit 1; \
	else \
		cd clinical_curator_server && dart run bin/seed.dart; \
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
		echo "  ❌ Serverpod    — not running (make server-start)"; \
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
	@echo "   Run 'make app-run-web' to start the Flutter app"
	@echo "   Run 'make status' to check services"
