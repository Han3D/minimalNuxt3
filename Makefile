APP_NAME := $(shell basename $(CURDIR))
APP_VERSION := $(shell git describe --tags --always --dirty)


docker: 
	docker build -t $(APP_NAME):$(APP_VERSION) .

run:
	docker run -p 3000:3000 $(APP_NAME):$(APP_VERSION)

version:
	@echo $(APP_NAME) - $(APP_VERSION)

.PHONY: docker run