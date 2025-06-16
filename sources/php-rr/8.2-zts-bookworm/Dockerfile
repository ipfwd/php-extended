ARG PHP_VERSION="8.4"
ARG PHP_FROM="ipfwd/php-extended:$(PHP_VERSION)-zts-bookworm"
ARG RR_VERSION="2025.1.2"
ARG RR_SHA256SUM="abac9a924e96ebce7f9f39e9497ff14096dd1bb90af2719bfb03997cfd524f4e"

ARG GO_VERSION="1.24.4"
ARG GO_SHA256SUM="77e5da33bb72aeaef1ba4418b6fe511bc4d041873cbf82e5aa6318740df98717"

FROM ${PHP_FROM} AS roadrunner

WORKDIR /usr/src/go

ARG RR_VERSION
ENV RR_VERSION=${RR_VERSION}
ARG RR_SHA256SUM
ENV RR_SHA256SUM=${RR_SHA256SUM}

ARG GO_VERSION
ENV GO_VERSION=${GO_VERSION}
ARG GO_SHA256SUM
ENV GO_SHA256SUM=${GO_SHA256SUM}

ENV LDFLAGS="-s \
-X github.com/roadrunner-server/roadrunner/v2025/internal/meta.version=v${RR_VERSION} \
-X github.com/roadrunner-server/roadrunner/v2025/internal/meta.buildTime=0"

USER root

RUN apt update && apt install -y wget openssl \
    && wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz \
    && (echo "${GO_SHA256SUM} go${GO_VERSION}.linux-amd64.tar.gz" | sha256sum --check --status) \
    && rm -rf /usr/local/go && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz \
    && export PATH=$PATH:/usr/local/go/bin \
    && wget https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v${RR_VERSION}.tar.gz \
    && (echo "${RR_SHA256SUM} v${RR_VERSION}.tar.gz" | sha256sum --check --status) \
    && tar -C /tmp -xzf v${RR_VERSION}.tar.gz \
    && cd /tmp/roadrunner-${RR_VERSION} \
    && go mod download \
    && go mod tidy \
    && CGO_ENABLED=0 go build -pgo=roadrunner.pprof -trimpath -ldflags "$LDFLAGS" -o /usr/bin/rr ./cmd/rr


FROM ${PHP_FROM}

LABEL maintainer="Ipfwd Docker Images <docker@ipfwd.net>" \
    version="${PHP_VERSION}-rr-${RR_VERSION}" \
    description="Docker image with PHP ${PHP_VERSION} and RoadRunner ${RR_VERSION}" \
    org.opencontainers.image.source="https://github.com/ipfwd/php-extended" \
    org.opencontainers.image.authors='Ipfwd "docker@ipfwd.net"' \
    net.ipfwd.image="true"

COPY --from=roadrunner /usr/bin/rr /usr/local/bin/rr

ONBUILD RUN echo $(date +%m%d%H%M) | sudo tee /build-date.txt;

CMD []
ENTRYPOINT ["rr"]
