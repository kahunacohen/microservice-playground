# make builds all services
# make clean cleans
# make run SERVICE=identity-service runs one service
# ===== Makefile =====

# List all services
SERVICES := identity-service scheduling-service

# Default target: build all services
all: build

# Build all services
build:
	@for svc in $(SERVICES); do \
		echo "Building $$svc..."; \
		docker build -t $$svc:latest $$svc; \
	done

# Run a single service (default: identity-service)
SERVICE ?= identity-service
run: 
	docker run --rm -p 8080:8080 -p 9090:9090 $(SERVICE):latest

# Clean all images
clean:
	@for svc in $(SERVICES); do \
		echo "Removing $$svc image..."; \
		docker rmi -f $$svc:latest; \
	done

.PHONY: all build run clean

