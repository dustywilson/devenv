#!/bin/bash

DISTRO_NAME=ubuntu
DISTRO_VERSION=17.10
PROTOC_VERSION=3.5.1

cd "$(dirname "$(readlink -f "$0")")"

docker build \
	--build-arg DISTRO_NAME=${DISTRO_NAME} \
	--build-arg DISTRO_VERSION=${DISTRO_VERSION} \
	--build-arg PROTOC_VERSION=${PROTOC_VERSION} \
	-t dustywilson/devenv:build-protoc-${PROTOC_VERSION}-${DISTRO_NAME}_${DISTRO_VERSION} \
	protoc

