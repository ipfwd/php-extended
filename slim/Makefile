SHELL = bash
SLIM_VERSION = 1.41.7

.SILENT: build-image slim

build-image:
	curl -L -o ds.tar.gz https://github.com/mintoolkit/mint/releases/download/${SLIM_VERSION}/dist_linux.tar.gz; \
        tar -xvf ds.tar.gz
	docker build --build-arg "SLIM_VERSION=$(SLIM_VERSION)" -t ipfwd/docker-slim:$(SLIM_VERSION) -t ipfwd/docker-slim:latest -f Dockerfile .
	docker push ipfwd/docker-slim:$(SLIM_VERSION)
	docker push ipfwd/docker-slim:latest

slim:
#	slim build --http-probe=false --http-probe-off --tag "$(IMAGE)-slim" $(IMAGE)
	docker run --rm -v "/var/run/docker.sock:/var/run/docker.sock" --entrypoint=mint ipfwd/docker-slim slim \
		--http-probe=false --sensor-ipc-mode direct --continue-after exec --exec php \
		--include-bin php \
		--include-bin php-fpm \
		--include-path /usr/local/etc/ \
		--include-path /usr/lib64 \
		--include-path /lib \
		--include-path /lib64 \
		--http-probe-off --tag "$(IMAGE)-slim" \
		 $(IMAGE)
	docker push $(IMAGE)-slim

secscan-slim:
	docker run -v "$(WORK_DIR):/data" aquasec/trivy image --severity UNKNOWN,LOW,MEDIUM,HIGH,CRITICAL --format template --template "@contrib/html.tpl" -o /data/trivy-slim.html $(IMAGE)-slim
