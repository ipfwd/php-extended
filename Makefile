SHELL = bash

.SILENT: build

build:
ifndef PHP_VERSION
	$(error Define PHP_VERSION to build image)
endif
	docker build --build-arg "PHP_VERSION=$(PHP_VERSION)" -t ipfwd/php-extended:$(PHP_VERSION) -t ipfwd/php-extended:latest .

push:
ifndef PHP_VERSION
	$(error Define PHP_VERSION to push image)
endif
	docker push ipfwd/php-extended:$(PHP_VERSION)
	docker push ipfwd/php-extended:latest
