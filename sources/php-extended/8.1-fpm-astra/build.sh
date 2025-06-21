#!/bin/sh

docker build --pull --build-arg "PHP_VERSION=8.1" --build-arg "ADVANCED_LIBS=" --build-arg "PHP_FROM=ipfwd/php-astra:8.1-fpm" -f Dockerfile -t ipfwd/php-extended:8.1-fpm-astra .
