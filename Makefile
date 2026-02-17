REGISTRY ?= docker.io
IMAGE ?= bborbe/teamvault
VERSION ?= 0.11.6

default: build

.PHONY: build
build:
	DOCKER_BUILDKIT=1 \
	docker build \
	--no-cache \
	--rm=true \
	--platform=linux/amd64 \
	--build-arg VERSION=$(VERSION) \
	--build-arg BUILD_GIT_VERSION=$$(git describe --tags --always --dirty) \
	--build-arg BUILD_GIT_COMMIT=$$(git rev-parse --short HEAD) \
	--build-arg BUILD_DATE=$$(date -u +%Y-%m-%dT%H:%M:%SZ) \
	-t $(REGISTRY)/$(IMAGE):$(VERSION) \
	-f Dockerfile .

.PHONY: upload
upload:
	docker push $(REGISTRY)/$(IMAGE):$(VERSION)

.PHONY: clean
clean:
	docker rmi $(REGISTRY)/$(IMAGE):$(VERSION) || true

.PHONY: run
run:
	docker-compose up

.PHONY: start
start:
	docker-compose up -d

.PHONY: stop
stop:
	docker-compose down

.PHONY: logs
logs:
	docker-compose logs -f

.PHONY: superuser
superuser:
	docker-compose exec teamvault teamvault plumbing createsuperuser
