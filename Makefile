VERSION ?= latest
REGISTRY ?= docker.io
BRANCH ?= email-config
REPO ?= https://github.com/bborbe/teamvault.git

default: build

checkout:
	git -C sources pull || git clone -b $(BRANCH) --single-branch --depth 1 $(REPO) sources

clean:
	rm -rf sources
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
