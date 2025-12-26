# Makefile for Predictive Inference Project (Poetry + Devcontainer)
# ================================================================

SHELL := /bin/bash
PYTHON := poetry run python
POETRY := poetry
SCRIPTS_DIR := scripts
DATA_DIR := data
SRC_DIR := src
ROOT_DIR := pdf_analyzer
TEST_DIR := tests
PDFPLUMBER_LOADER_DIR := $(SRC_DIR)/load_data/submodules/pdfplumber_loader

RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
MAGENTA := \033[0;35m
CYAN := \033[0;36m
RESET := \033[0m
BOLD := \033[1m

.PHONY: help env install dev test clean cov docs lint format check build deploy

# -----------------------------
# Help target (improved UX)
# -----------------------------
help: ## Show this help message with categories
	@echo "==============================================="
	@echo "${BOLD}${CYAN}Predictive Inference Project - Makefile Help${RESET}"
	@echo "==============================================="
	@echo ""
	@echo "${BOLD}${YELLOW}📦 Environment & Setup:${RESET}"
	@awk -F ':.*##' '/^[a-zA-Z_-]+:.*##.*env/ {printf "  ${GREEN}%-20s${RESET} %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "${BOLD}${YELLOW}🧪 Testing & Quality:${RESET}"
	@awk -F ':.*##' '/^[a-zA-Z_-]+:.*##.*test/ {printf "  ${GREEN}%-20s${RESET} %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "${BOLD}${YELLOW}🚀 Development & Run:${RESET}"
	@awk -F ':.*##' '/^[a-zA-Z_-]+:.*##.*dev/ {printf "  ${GREEN}%-20s${RESET} %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "${BOLD}${YELLOW}📊 Monitoring & Analysis:${RESET}"
	@awk -F ':.*##' '/^[a-zA-Z_-]+:.*##.*monitor/ {printf "  ${GREEN}%-20s${RESET} %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "${BOLD}${YELLOW}🧹 Cleanup:${RESET}"
	@awk -F ':.*##' '/^[a-zA-Z_-]+:.*##.*clean/ {printf "  ${GREEN}%-20s${RESET} %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# -----------------------------
# Environment setup (enhanced)
# -----------------------------
env: ## Install production dependencies via Poetry
	@echo "${BLUE}Installing project dependencies via Poetry...${RESET}"
	@$(POETRY) install --no-dev
	@echo "${GREEN}✅ Production dependencies installed${RESET}"

dev: pyproject.toml ## Install all dependencies including dev tools
	@echo "${BLUE}Installing all dependencies (including dev)...${RESET}"
	@$(POETRY) install
	@echo "${GREEN}✅ All dependencies installed${RESET}"

install: dev ## Alias for dev installation

poetry_shell: ## Enter the Poetry virtual environment
	@echo "${BLUE}Entering Poetry shell...${RESET}"
	@$(POETRY) shell

# -----------------------------
# Testing & Quality (comprehensive)
# -----------------------------
test: ## Run all tests
	@echo "${BLUE}Running all tests...${RESET}"
	@$(POETRY) run pytest $(TEST_DIR)/ -v --tb=short

test-unit: ## Run only unit tests
	@echo "${BLUE}Running unit tests...${RESET}"
	@$(POETRY) run pytest $(TEST_DIR)/test_unit/ -v --tb=short

test-integration: ## Run only integration tests (requires --run-integration)
	@echo "${BLUE}Running integration tests...${RESET}"
	@$(POETRY) run pytest $(TEST_DIR)/test_integration/ -v --run-integration --tb=short

test-performance: ## Run performance tests (requires --run-performance)
	@echo "${BLUE}Running performance tests...${RESET}"
	@$(POETRY) run pytest $(TEST_DIR)/test_performance/ -v --run-performance --tb=short

test-cov: ## Run tests with coverage report
	@echo "${BLUE}Running tests with coverage...${RESET}"
	@$(POETRY) run pytest $(TEST_DIR)/ --cov=extractor --cov-report=html --cov-report=term-missing
	@echo "${GREEN}Coverage report generated: htmlcov/index.html${RESET}"

test-pdfprocessor: ## Test PDF processor specifically
	@echo "${BLUE}Testing PDF Processor...${RESET}"
	@pytest -vv extractor/modules/pdf_processor/tests

lint: ## Run code linting (ruff, black, mypy)
	@echo "${BLUE}Running code linting...${RESET}"
	@$(POETRY) run ruff check .
	@$(POETRY) run black --check .
	@$(POETRY) run mypy .
	@echo "${GREEN}✅ Linting passed${RESET}"

format: ## Auto-format code
	@echo "${BLUE}Formatting code...${RESET}"
	@$(POETRY) run black .
	@$(POETRY) run ruff check --fix .
	@echo "${GREEN}✅ Code formatted${RESET}"

type-check: ## Run type checking only
	@$(POETRY) run mypy .

# -----------------------------
# Development & Run (new features)
# -----------------------------
run: ## Run the main application
	@echo "${BLUE}Running main application...${RESET}"
	@$(POETRY) run python -m extractor.extractor --max-files 3

dev-server: ## Start development server with auto-reload
	@echo "${BLUE}Starting dev server with auto-reload...${RESET}"
	@$(POETRY) run watchfiles "python -m extractor.main" .

jupyter: ## Start Jupyter lab for exploration
	@echo "${BLUE}Starting Jupyter Lab...${RESET}"
	@$(POETRY) run jupyter lab

notebook: ## Create a new Jupyter notebook
	@$(POETRY) run jupyter notebook --notebook-dir=./notebooks

pdfplumber-load: ## Load PDF files using pdfplumber
	@echo "${BLUE}Loading PDF files using pdfplumber...${RESET}"
	@$(POETRY) run python $(PDFPLUMBER_LOADER_DIR)/pdfplumber_process.py

benchmark: ## Run performance benchmarks
	@echo "${BLUE}Running performance benchmarks...${RESET}"
	@$(POETRY) run python -m tests.test_performance.test_benchmark

# -----------------------------
# Monitoring & Analysis
# -----------------------------
profile: ## Profile code performance
	@echo "${BLUE}Profiling code...${RESET}"
	@$(POETRY) run python -m cProfile -o profile_stats.prof -m extractor.main
	@echo "${GREEN}Profile saved to profile_stats.prof${RESET}"

view-profile: ## View profiling results
	@$(POETRY) run snakeviz profile_stats.prof

deps-tree: ## Show dependency tree
	@$(POETRY) show --tree

deps-outdated: ## Check for outdated dependencies
	@$(POETRY) show --outdated

check-versions: ## Check versions of key dependencies
	@echo "${BLUE}Checking dependency versions...${RESET}"
	@$(POETRY) run python -c "\
	import pandas; print(f'pandas: {pandas.__version__}'); \
	import sklearn; print(f'scikit-learn: {sklearn.__version__}'); \
	import pytest; print(f'pytest: {pytest.__version__}'); \
	import numpy; print(f'numpy: {numpy.__version__}'); \
	import polars; print(f'polars: {polars.__version__}')"

run-psb: ## run the psb version of the application
	@echo "${BLUE}Running PSB application...${RESET}"
	@$(PYTHON) -m psb.cli find-pdfs data

# -----------------------------
# Documentation
# -----------------------------
docs: ## Generate documentation
	@echo "${BLUE}Generating documentation...${RESET}"
	@$(POETRY) run pdoc --html extractor --output-dir docs
	@echo "${GREEN}Docs generated: docs/extractor/${RESET}"

serve-docs: ## Serve documentation locally
	@echo "${BLUE}Serving documentation...${RESET}"
	@python -m http.server 8000 --directory docs/extractor/

# -----------------------------
# Build & Deployment
# -----------------------------
build: ## Build package for distribution
	@$(POETRY) build

publish: ## Publish to PyPI (dry-run first)
	@$(POETRY) publish --dry-run
	@echo "${YELLOW}Run 'make publish-real' to actually publish${RESET}"

publish-real: ## Actually publish to PyPI
	@$(POETRY) publish

docker-build: ## Build Docker image
	@docker build -t pdf-analyzer .

docker-run: ## Run in Docker
	@docker run -it --rm pdf-analyzer

# -----------------------------
# Cleaning targets
# -----------------------------
clean: ## Remove all generated files
	@echo "${BLUE}Cleaning generated files...${RESET}"
	@rm -rf .pytest_cache/ .mypy_cache/ .ruff_cache/ .coverage htmlcov/ profile_stats.prof
	@find . -name "*.pyc" -delete
	@find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
	@echo "${GREEN}✅ Clean complete${RESET}"

clean-all: clean ## Remove everything including build artifacts
	@rm -rf dist/ build/ *.egg-info/ .ipynb_checkpoints/
	@echo "${GREEN}✅ Full clean complete${RESET}"

# -----------------------------
# Utility functions
# -----------------------------
define log
	@echo "[$(shell date '+%Y-%m-%d %H:%M:%S')] $(1)" >> project.log
endef

# -----------------------------
# Quick development commands
# -----------------------------
quick-test: ## Quick test run (no verbose)
	@$(POETRY) run pytest $(TEST_DIR)/test_unit/ -x

quick-lint: ## Quick lint check
	@$(POETRY) run ruff check .

quick-format: ## Quick format check
	@$(POETRY) run black --check .

dev-loop: ## Development loop: format → lint → test
	@make quick-format && make quick-lint && make quick-test

# -----------------------------
# Git integration
# -----------------------------
pre-commit: ## Run pre-commit checks
	@make format
	@make lint
	@make test-unit

git-hooks: ## Install git hooks
	@echo "#!/bin/bash" > .git/hooks/pre-commit
	@echo "make pre-commit" >> .git/hooks/pre-commit
	@chmod +x .git/hooks/pre-commit
	@echo "${GREEN}✅ Git hooks installed${RESET}"

# -----------------------------
# Project status
# -----------------------------
status: ## Show project status
	@echo "${BOLD}Project Status:${RESET}"
	@echo "Dependencies: $(shell $(POETRY) check && echo '✅ OK' || echo '❌ Issues')"
	@echo "Tests: $(shell make quick-test >/dev/null 2>&1 && echo '✅ Passing' || echo '❌ Failing')"
	@echo "Linting: $(shell make quick-lint >/dev/null 2>&1 && echo '✅ Clean' || echo '❌ Issues')"

.DEFAULT_GOAL := help
