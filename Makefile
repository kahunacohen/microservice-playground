# ===== Makefile at microservice-playground/ =====

# Variables
SERVICE_NAME := identity-service
DOCKER_IMAGE := $(SERVICE_NAME):latest
SERVICE_DIR := $(SERVICE_NAME)

# Default target
all: build

# Build the Docker image
build:
	docker build -t $(DOCKER_IMAGE) $(SERVICE_DIR)

# Run the Docker image locally
run: build
	docker run --rm -p 8080:8080 -p 9090:9090 $(DOCKER_IMAGE)

# Clean images
clean:
	docker rmi -f $(DOCKER_IMAGE)

.PHONY: all build run clean

