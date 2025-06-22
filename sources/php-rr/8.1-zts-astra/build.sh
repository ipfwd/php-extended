docker build --pull 	--build-arg PHP_VERSION=8.1 	--build-arg PHP_FROM=ipfwd/php-extended:8.1-zts-astra 	-f Dockerfile  		-t ipfwd/php-extended:8.1-rr-astra  		-t ipfwd/php-rr:8.1-zts-astra  		.
