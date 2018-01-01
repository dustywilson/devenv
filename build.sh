#!/bin/bash -e

DISTRO_NAME=ubuntu
DISTRO_VERSION=17.10
PROTOC_VERSION=3.5.1
HELM_VERSION=2.7.2
GO_VERSION=1.9.2
ATOM_VERSION=1.23.1
GAESDK_VERSION=1.9.61
NODE_REPOVER=9.x
MONGO_REPOVER=3.6
MONGO_DISTRO_NAME=xenial


cd "$(dirname "$(readlink -f "$0")")"


PREFIX_NAME="dustywilson/devenv"
COMMIT_NAME="$(TZ=UTC git log --date=format-local:"%Y%m%d%H%m" --pretty=format:"%cd-%h" -n1)"
NOT_COMMITTED=
if git status --porcelain | egrep -i "^\s*[MD]" >/dev/null; then
	COMMIT_NAME="$(date -u +"%Y%m%d%H%M-badwolf")"
	NOT_COMMITTED=1
fi
VERSION="${COMMIT_NAME}-go${GO_VERSION}-node${NODE_REPOVER}-mongo${MONGO_REPOVER}-${DISTRO_NAME}${DISTRO_VERSION}-atom${ATOM_VERSION}"


# Base Image (includes bare essentials, such as curl and git)

docker build \
	--build-arg PREFIX_NAME=${PREFIX_NAME} \
	--build-arg COMMIT_NAME=${COMMIT_NAME} \
	--build-arg DISTRO_NAME=${DISTRO_NAME} \
	--build-arg DISTRO_VERSION=${DISTRO_VERSION} \
	-t ${PREFIX_NAME}:base-${DISTRO_NAME}${DISTRO_VERSION} \
	base


# Programming Fonts Collection

docker build \
	--build-arg PREFIX_NAME=${PREFIX_NAME} \
	--build-arg COMMIT_NAME=${COMMIT_NAME} \
	--build-arg DISTRO_NAME=${DISTRO_NAME} \
	--build-arg DISTRO_VERSION=${DISTRO_VERSION} \
	-t ${PREFIX_NAME}:build-fonts \
	fonts


# Actions on Google

docker build \
	--build-arg PREFIX_NAME=${PREFIX_NAME} \
	--build-arg COMMIT_NAME=${COMMIT_NAME} \
	--build-arg DISTRO_NAME=${DISTRO_NAME} \
	--build-arg DISTRO_VERSION=${DISTRO_VERSION} \
	-t ${PREFIX_NAME}:build-gactions \
	gactions


# Protocol Buffers

docker build \
	--build-arg PREFIX_NAME=${PREFIX_NAME} \
	--build-arg COMMIT_NAME=${COMMIT_NAME} \
	--build-arg DISTRO_NAME=${DISTRO_NAME} \
	--build-arg DISTRO_VERSION=${DISTRO_VERSION} \
	--build-arg PROTOC_VERSION=${PROTOC_VERSION} \
	-t ${PREFIX_NAME}:build-protoc${PROTOC_VERSION}-${DISTRO_NAME}${DISTRO_VERSION} \
	protoc


# Kubernetes Helm

docker build \
	--build-arg PREFIX_NAME=${PREFIX_NAME} \
	--build-arg COMMIT_NAME=${COMMIT_NAME} \
	--build-arg DISTRO_NAME=${DISTRO_NAME} \
	--build-arg DISTRO_VERSION=${DISTRO_VERSION} \
	--build-arg HELM_VERSION=${HELM_VERSION} \
	-t ${PREFIX_NAME}:build-helm${HELM_VERSION} \
	helm


# Go

docker build \
	--build-arg PREFIX_NAME=${PREFIX_NAME} \
	--build-arg COMMIT_NAME=${COMMIT_NAME} \
	--build-arg DISTRO_NAME=${DISTRO_NAME} \
	--build-arg DISTRO_VERSION=${DISTRO_VERSION} \
	--build-arg GO_VERSION=${GO_VERSION} \
	-t ${PREFIX_NAME}:build-go${GO_VERSION} \
	go


# Google App Engine Go SDK

docker build \
	--build-arg PREFIX_NAME=${PREFIX_NAME} \
	--build-arg COMMIT_NAME=${COMMIT_NAME} \
	--build-arg DISTRO_NAME=${DISTRO_NAME} \
	--build-arg DISTRO_VERSION=${DISTRO_VERSION} \
	--build-arg GAESDK_VERSION=${GAESDK_VERSION} \
	-t ${PREFIX_NAME}:build-gaesdk${GAESDK_VERSION} \
	gaesdk


# The Composite Build

LATEST=
[ -z $NOT_COMMITTED ] && LATEST="-t ${PREFIX_NAME}:latest"

docker build \
	--build-arg PREFIX_NAME=${PREFIX_NAME} \
	--build-arg COMMIT_NAME=${COMMIT_NAME} \
	--build-arg DISTRO_NAME=${DISTRO_NAME} \
	--build-arg DISTRO_VERSION=${DISTRO_VERSION} \
	--build-arg PROTOC_VERSION=${PROTOC_VERSION} \
	--build-arg HELM_VERSION=${HELM_VERSION} \
	--build-arg GO_VERSION=${GO_VERSION} \
	--build-arg ATOM_VERSION=${ATOM_VERSION} \
	--build-arg GAESDK_VERSION=${GAESDK_VERSION} \
	--build-arg NODE_REPOVER=${NODE_REPOVER} \
	--build-arg MONGO_REPOVER=${MONGO_REPOVER} \
	--build-arg MONGO_DISTRO_NAME=${MONGO_DISTRO_NAME} \
	-t ${PREFIX_NAME}:${VERSION}-${DISTRO_NAME}${DISTRO_VERSION} ${LATEST} \
	devenv


# Push!

if [ -z $NOT_COMMITTED ]; then
	docker push ${PREFIX_NAME}:base-${DISTRO_NAME}${DISTRO_VERSION}
	docker push ${PREFIX_NAME}:build-fonts
	docker push ${PREFIX_NAME}:build-gactions
	docker push ${PREFIX_NAME}:build-protoc${PROTOC_VERSION}-${DISTRO_NAME}${DISTRO_VERSION}
	docker push ${PREFIX_NAME}:build-helm${HELM_VERSION}
	docker push ${PREFIX_NAME}:build-go${GO_VERSION}
	docker push ${PREFIX_NAME}:build-gaesdk${GAESDK_VERSION}
	docker push ${PREFIX_NAME}:${VERSION}-${DISTRO_NAME}${DISTRO_VERSION}
	docker push ${PREFIX_NAME}:latest
fi
