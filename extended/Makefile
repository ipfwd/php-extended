SHELL = bash
PHP_VERSION = 8.4
PHP_TYPE = zts
PHP_DISTRO = bookworm
PHP_FROM = "php:$(PHP_VERSION)-$(PHP_TYPE)-$(PHP_DISTRO)"
ADVANCED_LIBS = ""

WORK_DIR="../../sources/php-extended/$(PHP_VERSION)-$(PHP_TYPE)-$(PHP_DISTRO)"

.SILENT: build

-include ../slim/Makefile

all:
	$(MAKE) -s fetch PHP_VERSION=$(PHP_VERSION) PHP_TYPE=$(PHP_TYPE) PHP_DISTRO=$(PHP_DISTRO) PHP_FROM=$(PHP_FROM)
	$(MAKE) -s build PHP_VERSION=$(PHP_VERSION) PHP_TYPE=$(PHP_TYPE) PHP_DISTRO=$(PHP_DISTRO) PHP_FROM=$(PHP_FROM)
	$(MAKE) -s push PHP_VERSION=$(PHP_VERSION) PHP_TYPE=$(PHP_TYPE) PHP_DISTRO=$(PHP_DISTRO) PHP_FROM=$(PHP_FROM)
	$(MAKE) -s publish PHP_VERSION=$(PHP_VERSION) PHP_TYPE=$(PHP_TYPE) PHP_DISTRO=$(PHP_DISTRO) PHP_FROM=$(PHP_FROM)
	$(MAKE) -s secscan PHP_VERSION=$(PHP_VERSION) PHP_TYPE=$(PHP_TYPE) PHP_DISTRO=$(PHP_DISTRO) PHP_FROM=$(PHP_FROM)
	$(MAKE) -s slim WORK_DIR=$(WORK_DIR) IMAGE=ipfwd/php-extended:$(PHP_VERSION)-$(PHP_TYPE)-$(PHP_DISTRO)
	$(MAKE) -s secscan-slim WORK_DIR=$(WORK_DIR) IMAGE=ipfwd/php-extended:$(PHP_VERSION)-$(PHP_TYPE)-$(PHP_DISTRO)

fetch:
	rm -rf $(WORK_DIR)
	mkdir -p $(WORK_DIR)
	cp Dockerfile $(WORK_DIR)/
	cp php.ini $(WORK_DIR)/

build:
	cd $(WORK_DIR); \
	echo -e "#!/bin/sh\n\ndocker build --pull --build-arg \"PHP_VERSION=$(PHP_VERSION)\" --build-arg \"ADVANCED_LIBS=$(ADVANCED_LIBS)\" --build-arg \"PHP_FROM=$(PHP_FROM)\" -f Dockerfile -t ipfwd/php-extended:$(PHP_VERSION)-$(PHP_TYPE)-$(PHP_DISTRO) ." > build.sh; \
	sh build.sh

push:
	docker push ipfwd/php-extended:$(PHP_VERSION)-$(PHP_TYPE)-$(PHP_DISTRO)

secscan:
	docker run -v "$(WORK_DIR):/data" aquasec/trivy image --severity UNKNOWN,LOW,MEDIUM,HIGH,CRITICAL --format template --template "@contrib/html.tpl" -o /data/trivy.html ipfwd/php-extended:$(PHP_VERSION)-$(PHP_TYPE)-$(PHP_DISTRO)

publish:
	tree $(WORK_DIR)

