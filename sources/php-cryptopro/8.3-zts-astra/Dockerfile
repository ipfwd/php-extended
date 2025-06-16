ARG PHP_VERSION="8.4"
ARG PHP_FROM="ipfwd/php-extended:${PHP_VERSION}-zts-astra"

FROM php:${PHP_VERSION}-zts-bookworm AS phpsource
FROM ${PHP_FROM} AS builder

ENV PHP_VERSION="${PHP_VERSION}"

USER root

COPY --from=phpsource /usr/src/php.tar.xz /usr/src/php.tar.xz

COPY dist/linux-amd64_deb.tgz /tmp/cprocsp/linux-amd64_deb.tgz

RUN cd /tmp/cprocsp && \
    tar zxvf linux-amd64_deb.tgz && \
    cd linux-amd64_deb && \
    ./uninstall.sh && \
    ./install.sh && \
    ./install.sh lsb-cprocsp-devel cprocsp-pki-cades && \
    rm -rf /tmp/cprocsp

RUN docker-php-source extract && \
    apt update && apt install --no-install-recommends -y libboost-dev libxml2-dev && \
    cd /tmp && git clone https://github.com/CryptoPro/phpcades.git && cd phpcades && \
    sed -i -e "s#PHPDIR=/php#PHPDIR=/usr/local/include/php#g" Makefile.unix && \
    eval `/opt/cprocsp/src/doxygen/CSP/../setenv.sh --64`&& make -f Makefile.unix && \
    EXT_DIR="$(php -i | grep ^extension_dir | awk '{print $3}')" && cp ./libphpcades.so "${EXT_DIR}/" && \
    INI_DIR="$(php -i | grep 'dir for additional .ini files' | awk '{print $9}')" &&  echo $INI_DIR && \
    echo "extension=libphpcades.so" > "${INI_DIR}/libphpcades.ini" && \
    rm -rf /tmp/phpcades /usr/src/php.* && \
    docker-php-source delete

USER app

LABEL maintainer="Ipfwd Docker Images <docker@ipfwd.net>" \
    version="${PHP_VERSION}-cryptopro" \
    description="Docker image with PHP ${PHP_VERSION} and CryptoPro with phpcades extension" \
    org.opencontainers.image.source="https://github.com/ipfwd/php-extended" \
    org.opencontainers.image.authors='Ipfwd "docker@ipfwd.net"' \
    net.ipfwd.image="true"
