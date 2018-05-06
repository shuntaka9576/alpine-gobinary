DOCKERCMD=docker
DOCKERBUILD=$(DOCKERCMD) build
DOCKERSTOP=$(DOCKERCMD) stop
DOCKERPS=$(DOCKERCMD) ps
DOCKERRM=$(DOCKERCMD) rm
DOCKERIMAGES=$(DOCKERCMD) images
DOCKEREXEC=$(DOCKERCMD) exec
DOCKERRUN=$(DOCKERCMD) run

GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
BINARY_NAME=hello
DOCKER_REGISTRY=alpine-gobinary
CONTAINER_NAME=alpine-container

build:
	GOARCH=amd64 GOOS=linux $(GOBUILD) -o $(BINARY_NAME)
	$(DOCKERBUILD) -t $(DOCKER_REGISTRY):latest .
clean:
	-$(GOCLEAN) && rm $(BINARY_NAME)
	# コンテナ停止
	$(DOCKERPS) | grep $(DOCKER_REGISTRY) | awk '{print $$1}' | xargs $(DOCKERSTOP)
	# コンテナ削除
	$(DOCKERPS) -a | grep $(DOCKER_REGISTRY) | awk '{print $$1}' | xargs $(DOCKERRM)
	# イメージ削除
	$(DOCKERIMAGES)| grep $(DOCKER_REGISTRY) | awk '{print $$3}' | xargs docker rmi -f
	# 確認
	echo && $(DOCKERPS) -a && echo && $(DOCKERIMAGES)
run:
	-$(DOCKERSTOP) $(CONTAINER_NAME)
	-$(DOCKERRM) $(CONTAINER_NAME)
	$(DOCKERRUN) -d --name $(CONTAINER_NAME) -t $(DOCKER_REGISTRY) 
	echo && $(DOCKERPS)
	echo && $(DOCKERPS) -a
in:
	$(DOCKEREXEC) -it $(CONTAINER_NAME) /bin/sh