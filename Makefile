APP_VERSION := $(shell git describe --tags --always --dirty)


docker: 
	docker build -t han3d/minimalnuxt3:$(APP_VERSION) .

run:
	docker run -p 3000:3000 han3d/minimalnuxt3:$(APP_VERSION)

version:
	@echo han3d/minimalnuxt3 - $(APP_VERSION)

.PHONY: docker run