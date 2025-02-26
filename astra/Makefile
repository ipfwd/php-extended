SHELL = bash

.SILENT: build

build:
ifndef PHP_VERSION
	$(error Define PHP_VERSION to build image)
endif
	mkdir -p "$(PHP_VERSION)"
	@files=("docker-php-entrypoint" "docker-php-ext-configure" "docker-php-ext-enable" "docker-php-ext-install" "docker-php-source"); \
	base_url="https://raw.githubusercontent.com/docker-library/php/refs/heads/master/$(PHP_VERSION)/bookworm/zts"; \
	for file in $${files[@]}; do \
		curl -sSL "$${base_url}/$${file}" -o "$(PHP_VERSION)/$${file}"; \
		chmod a+x "$(PHP_VERSION)/$${file}"; \
	done
	sed -i -e 's#FROM debian:bookworm-slim#FROM registry.astralinux.ru/library/astra/ubi18:1.8#g' $(PHP_VERSION)/Dockerfile
	docker build -t ipfwd/php-astra:$(PHP_VERSION)-zts -f $(PHP_VERSION)/Dockerfile $(PHP_VERSION)

push:
ifndef PHP_VERSION
	$(error Define PHP_VERSION to build image)
endif
	docker push -t ipfwd/php-astra:$(PHP_VERSION)-zts -f $(PHP_VERSION)/Dockerfile $(PHP_VERSION)
