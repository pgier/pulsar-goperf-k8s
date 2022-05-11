# Copyright 2020
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

all: push

#
# Docker tag with v prefix to differentiate the official release build, triggered by git tagging
# this is pushed to datastax Dockerhub repo
#
TAG ?= 0.0.1
PREFIX ?= zzzming/pulsar-goperf
GIT_COMMIT = $(shell git rev-list -1 HEAD)

goperf:
	go build -o bin/goperf -ldflags "-X main.gitCommit=$(GIT_COMMIT)" src/*.go

build: goperf

test:
	go test ./...

container:
	docker build -t $(PREFIX):$(TAG) .
	docker tag $(PREFIX):$(TAG) ${PREFIX}:latest 

push: container
	docker push $(PREFIX):$(TAG)
	docker push $(PREFIX):latest

clean:
	go clean --cache
	docker rmi $(PREFIX):$(TAG)

static-check: lint

lint:
	golint -set_exit_status ./...

