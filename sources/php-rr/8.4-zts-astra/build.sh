docker build --pull 	--build-arg PHP_VERSION=8.4 	--build-arg PHP_FROM=ipfwd/php-extended:8.4-zts-astra 	-f Dockerfile  		-t ipfwd/php-extended:8.4-rr-astra  		-t ipfwd/php-rr:8.4-zts-astra  		.
