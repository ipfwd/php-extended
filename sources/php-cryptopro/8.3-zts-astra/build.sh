#!/bin/sh
docker build --pull 	--build-arg "PHP_VERSION=8.3" 	--build-arg "PHP_FROM=ipfwd/php-extended:8.3-zts-astra" 	-f Dockerfile  		-t ipfwd/php-extended:8.3-cryptopro-astra  		-t ipfwd/php-cryptopro:8.3-zts-astra  		.
