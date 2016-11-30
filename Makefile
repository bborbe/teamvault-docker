VERSION ?= latest

default: build

clean:
	docker rmi bborbe/teamvault:$(VERSION)

build:
	docker build --no-cache --rm=true -t bborbe/teamvault:$(VERSION) .

run:
	docker run -h example.com -p 8000:8000 bborbe/teamvault:$(VERSION)

shell:
	docker run -i -t bborbe/teamvault:$(VERSION) /bin/bash

upload:
	docker push bborbe/teamvault:$(VERSION)
