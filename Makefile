MRUBY_VERSION := 3.2.0
IMAGE_TAG := buty4649/mruby-build:$(MRUBY_VERSION)

.PHONY: build
build:
	docker buildx build -t $(IMAGE_TAG) --build-arg MRUBY_VERSION=$(MRUBY_VERSION) .
