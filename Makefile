VERSION ?= 1.0.0

default: build

clean:
	docker rmi bborbe/teamvault:$(VERSION)

build:
	docker build --build-arg VERSION=$(VERSION) --no-cache --rm=true -t bborbe/teamvault:$(VERSION) .

run:
	docker run -h example.com -p 8000:8000 bborbe/teamvault:$(VERSION)

shell:
	docker run -i -t bborbe/teamvault:$(VERSION) /bin/bash

upload:
	docker push bborbe/teamvault:$(VERSION)
