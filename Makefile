SHELL := bash
MAKEFLAGS += --warn-undefined-variables
.SHELLFLAGS := -euo pipefail -c

AUR_REMOTE := ssh://aur@aur.archlinux.org/protonvpn-cli.git
AUR_TEMP_DIR := /tmp/protonvpn-cli-aur-push

DOCKER_TAG := ddnomad/protonvpn-cli-buildpkg-test
DOCKER_RUN_OPTS := --rm -it


.PHONY: all
all:
	$(MAKE) dtest


###############################################################################
# Docker targets
###############################################################################
.PHONY: dbuild
dbuild:
	docker build . -t $(DOCKER_TAG) --build-arg host_user=`whoami`

.PHONY: dshell
dshell: dbuild
	docker run $(DOCKER_RUN_OPTS) $(DOCKER_TAG) --bypass /bin/bash -i

.PHONY: dtest
dtest: dbuild
	docker run $(DOCKER_RUN_OPTS) $(DOCKER_TAG) --test


###############################################################################
# Utility targets
###############################################################################
.PHONY: pushaur
pushaur: dtest
	bash ./pushaur.sh $(AUR_REMOTE) $(AUR_TEMP_DIR)
