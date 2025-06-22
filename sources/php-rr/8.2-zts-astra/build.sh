docker build --pull 	--build-arg PHP_VERSION=8.2 	--build-arg PHP_FROM=ipfwd/php-extended:8.2-zts-astra 	-f Dockerfile  		-t ipfwd/php-extended:8.2-rr-astra  		-t ipfwd/php-rr:8.2-zts-astra  		.
