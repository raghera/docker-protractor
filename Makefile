DOCKER_TAG ?= $(shell git describe --tags --first-parent | sed -nre '/([0-9]\.*)+([0-9])$\/p')
ENVFILE=./envfile

ifneq (,$(findstring cannot,$(DOCKER_TAG)))
	DOCKER_TAG=latest
endif

all:	build run

refresh-image:
	docker pull hortonworks/cloudbreak-web-e2e

run-gui-tests:
	DOCKER_TAG=$(DOCKER_TAG) ./scripts/e2e-gui-test.sh

build:
	docker build -t hortonworks/cloudbreak-web-e2e .

run:
	docker run -it \
       --privileged \
       --rm \
       --net=host \
       --name cloud-e2e-runner \
		--env-file $(ENVFILE) \
       -v /Users/transform/hmcts/ia-ccd-e2e-tests:/protractor/project \
       hortonworks/cloudbreak-web-e2e yarn e2e
    RESULT=$?
	# docker run -it \
	# 	--privileged \
	# 	--rm \
	# 	--net=host \
	# 	--name cloud-e2e-runner \
	# 	--env-file $(ENVFILE) \
	# 	-v $(PWD):/protractor/project \
	# 	hortonworks/cloudbreak-web-e2e:$(DOCKER_TAG) yarn test
	# RESULT=$?

.PHONY:
	all
