VERSION ?= latest
REGISTRY ?= docker.io
BRANCH ?= 0.6.1

default: build

checkout:
	git -C sources pull || git clone -b $(BRANCH) --single-branch --depth 1 https://github.com/trehn/teamvault.git sources
	#git -C sources pull || git clone -b email-config --single-branch --depth 1 https://github.com/bborbe/teamvault.git sources

clean:
	docker rmi $(REGISTRY)/bborbe/teamvault:$(VERSION)

build:
	docker build --build-arg VERSION=$(VERSION) --no-cache --rm=true -t $(REGISTRY)/bborbe/teamvault:$(VERSION) .

run:
	docker run \
	-p 8000:8000 \
	$(REGISTRY)/bborbe/teamvault:$(VERSION)

shell:
	docker run -i -t $(REGISTRY)/bborbe/teamvault:$(VERSION) /bin/bash

upload:
	docker push $(REGISTRY)/bborbe/teamvault:$(VERSION)
