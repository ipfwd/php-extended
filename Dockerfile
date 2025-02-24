ARG PHP_VERSION="8.4-zts-bookworm"
ARG PHP_EXTENSIONS="memcache redis mongodb inotify ds protobuf grpc imap ast xhprof opentelemetry gd gmp pdo_pgsql pgsql exif sockets bcmath opcache zip pcntl intl xsl xdebug"
ARG ADVANCED_TOOLS="openssh-client sudo git-core git-lfs mc jq uuid-runtime"
ARG COMPOSER_SETUP_HASH="dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6"

FROM mirror.gcr.io/library/php:${PHP_VERSION}

LABEL maintainer="Ipfwd Docker Images <docker@ipfwd.net>"
LABEL version="${PHP_VERSION}"
LABEL description="Docker image with PHP ${PHP_VERSION} and essential development tools"
LABEL org.opencontainers.image.source="https://github.com/ipfwd/php-extended"
LABEL org.opencontainers.image.authors='Ipfwd "docker@ipfwd.net"'
LABEL net.ipfwd.image="true"

ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/app/vendor/bin:/usr/local/share/composer/vendor/bin:/app/bin:/app"
ENV LANG=en_US.utf8

ARG ADVANCED_TOOLS
ENV ADVANCED_TOOLS=${ADVANCED_TOOLS}
RUN apt update; \
    apt install --no-install-recommends -y locales curl ${ADVANCED_TOOLS}

RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ARG PHP_EXTENSIONS
ENV PHP_EXTENSIONS=${PHP_EXTENSIONS}
RUN  --mount=type=bind,from=ghcr.io/mlocati/php-extension-installer:latest,source=/usr/bin/install-php-extensions,target=/usr/local/bin/install-php-extensions \
    install-php-extensions ${PHP_EXTENSIONS}

ARG COMPOSER_SETUP_HASH
ENV COMPOSER_SETUP_HASH=${COMPOSER_SETUP_HASH}
RUN cd /tmp && \
    curl https://getcomposer.org/installer -o composer-setup.php && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === '${COMPOSER_SETUP_HASH}') { echo 'Installer verified'.PHP_EOL; } else { echo 'Installer corrupt'.PHP_EOL; unlink('composer-setup.php'); exit(1); }" && \
    php composer-setup.php --install-dir=/usr/local/sbin --filename=composer && \
    chmod a+x /usr/local/sbin/composer && \
    php -r "unlink('composer-setup.php');"

ENV COMPOSER_HOME="/usr/local/share/composer"

RUN mkdir -p /usr/local/share/composer/vendor/bin && \
    curl -o /usr/local/share/composer/vendor/bin/phpcs \
         -L https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar && \
    curl -o /usr/local/share/composer/vendor/bin/phpcbf \
         -L https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar && \
    curl -o /usr/local/share/composer/vendor/bin/phpdocumentor \
         -L https://github.com/phpDocumentor/phpDocumentor/releases/download/v3.6.0/phpDocumentor.phar && \
    COMPOSER_MEMORY_LIMIT=-1 composer global require phan/phan && \
    COMPOSER_MEMORY_LIMIT=-1 composer global require rector/rector && \
    chmod a+x /usr/local/share/composer/vendor/bin/* && \
    echo "[done]"

RUN adduser --gecos --quiet --disabled-password --no-create-home --home /app app && \
    echo "app  ALL=NOPASSWD: ALL" >> /etc/sudoers

RUN \
    rm -rf /usr/share/doc && \
    rm -rf /usr/share/gitweb && \
    rm -rf /usr/src/* && \
    rm -rf /var/log/* && \
    rm -rf /usr/local/include/php/ext/* && \
    rm -rf /tmp/*

COPY php.ini /usr/local/etc/php/

RUN chown -R app:app /usr/local/share/composer
USER app

WORKDIR /app
STOPSIGNAL SIGTERM

CMD []
ENTRYPOINT ["php"]
