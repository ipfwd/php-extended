#!/bin/sh

docker build --pull --build-arg "PHP_VERSION=8.4" --build-arg "ADVANCED_LIBS=" --build-arg "PHP_FROM=ipfwd/php-astra:8.4-zts" -f Dockerfile -t ipfwd/php-extended:8.4-zts-astra .
