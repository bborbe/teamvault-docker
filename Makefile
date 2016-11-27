default: build

clean:
	docker rmi bborbe/teamvault

build:
	docker build --no-cache --rm=true -t bborbe/teamvault .

run:
	docker run -h example.com -p 8000:8000 bborbe/teamvault:latest

shell:
	docker run -i -t bborbe/teamvault:latest /bin/bash

upload:
	docker push bborbe/teamvault
