SHELL := bash
MAKEFLAGS += --warn-undefined-variables
.SHELLFLAGS := -euo pipefail -c

DOCKER_TAG := ddnomad/protonvpn-cli-buildpkg-test
DOCKER_RUN_OPTS := --rm -it


.PHONY: all
all:
	$(MAKE) test


.PHONY: build
build:
	docker build . -t $(DOCKER_TAG) --build-arg host_user=`whoami`


.PHONY: shell
shell: build
	docker run $(DOCKER_RUN_OPTS) $(DOCKER_TAG) --bypass /bin/bash -i

.PHONY: test
test: build
	docker run $(DOCKER_RUN_OPTS) $(DOCKER_TAG) --test
