REGISTRY ?= docker.io
IMAGE ?= bborbe/teamvault
ifeq ($(VERSION),)
	VERSION := $(shell git describe --tags `git rev-list --tags --max-count=1`)
endif

default: build

checkout:
	git -C sources pull || git clone -b master --single-branch --depth 1 https://github.com/trehn/teamvault sources

build:
	docker build --no-cache --rm=true -t $(REGISTRY)/$(IMAGE):$(VERSION) .

upload:
	docker push $(REGISTRY)/$(IMAGE):$(VERSION)

clean:
	docker rmi $(REGISTRY)/$(IMAGE):$(VERSION)

