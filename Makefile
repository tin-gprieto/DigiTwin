.PHONY: help install install-backend install-frontend \
	backend frontend dev test lint \
	docker-up docker-down docker-build

VENV := api-backend/.venv
PYTHON := $(VENV)/bin/python
PIP := $(VENV)/bin/pip

help:
	@echo "DigiTwin - comandos disponibles:"
	@echo "  make install           Instala dependencias del backend y frontend (en simultaneo)"
	@echo "  make backend           Levanta la API FastAPI (uvicorn --reload, :8000)"
	@echo "  make frontend          Levanta el frontend Next.js (pnpm dev, :3000)"
	@echo "  make dev               Levanta backend y frontend juntos"
	@echo "  make test              Corre los tests del backend (pytest)"
	@echo "  make lint              Corre el lint del frontend (eslint)"
	@echo "  make docker-up         Levanta todo el stack con docker compose"
	@echo "  make docker-down       Detiene el stack de docker compose"
	@echo "  make docker-build      Reconstruye las imagenes de docker compose"

install:
	$(MAKE) -j2 install-backend install-frontend

install-backend:
	python3 -m venv $(VENV)
	$(PIP) install -r api-backend/requirements.txt

install-frontend:
	cd app-mobile && pnpm install

backend:
	cd api-backend && ../$(PYTHON) -m uvicorn api.main:app --reload --port 8000

frontend:
	cd app-mobile && pnpm dev

dev:
	$(MAKE) -j2 backend frontend

test:
	cd api-backend && ../$(PYTHON) -m pytest tests/ -v

lint:
	cd app-mobile && pnpm lint

docker-up:
	docker compose up --build

docker-down:
	docker compose down

docker-build:
	docker compose build
