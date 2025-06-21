#!/bin/sh

docker build --pull --build-arg "PHP_VERSION=8.2" --build-arg "ADVANCED_LIBS=" --build-arg "PHP_FROM=php:8.2-fpm-bookworm" -f Dockerfile -t ipfwd/php-extended:8.2-fpm-bookworm .
