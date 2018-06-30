#!/bin/bash -e

DISTRO_NAME=ubuntu

# https://wiki.ubuntu.com/Releases
DISTRO_VERSION=18.04

# allow pulling of prebuilt image or update to make a new one
FONTS_BUILDDATE=20180630

# https://github.com/google/protobuf/releases - use release numbers without "v" prefix
PROTOC_VERSION=3.6.0

# https://storage.googleapis.com/kubernetes-helm/ and https://github.com/kubernetes/helm/releases
HELM_VERSION=2.9.1

# https://golang.org/dl/
GO_VERSION=1.10.3

# https://atom.io/
ATOM_VERSION=1.28.0

# https://storage.googleapis.com/appengine-sdks/ (last "featured/go_appengine_sdk_linux_amd64-(.*).zip" match)
GAESDK_VERSION=1.9.65

# https://deb.nodesource.com/node_(.*)
NODE_REPOVER=10.x

# https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/ and https://repo.mongodb.org/apt/ubuntu/dists/
# as 2018-06-30 there was no bionic (18.04) version, so we're using xenial (16.04)
MONGO_REPOVER=4.0
MONGO_DISTRO_NAME=xenial
MONGO_SIGNING_KEY=9DA31620334BD75D9DCB49F368818C72E52529D4


cd "$(dirname "$(readlink -f "$0")")"


IMAGE_NAME="dustywilson/devenv"
COMMIT_NAME="$(TZ=UTC git log --date=format-local:"%Y%m%d%H%m" --pretty=format:"%cd-%h" -n1)"
NOT_COMMITTED=
if git status --porcelain | egrep -i "^\s*[MD]" >/dev/null; then
	COMMIT_NAME="$(date -u +"%Y%m%d%H%M-badwolf")"
	NOT_COMMITTED=1
fi
VERSION_NOUI="${COMMIT_NAME}-go${GO_VERSION}-node${NODE_REPOVER}-mongo${MONGO_REPOVER}-${DISTRO_NAME}${DISTRO_VERSION}"
VERSION_FULL="${COMMIT_NAME}-go${GO_VERSION}-node${NODE_REPOVER}-mongo${MONGO_REPOVER}-${DISTRO_NAME}${DISTRO_VERSION}-atom${ATOM_VERSION}"


# Base Image (includes bare essentials, such as curl and git)

BASE_TAG="base-${DISTRO_NAME}${DISTRO_VERSION}"
echo ">> ${IMAGE_NAME}:${BASE_TAG}"
if docker images --format "{{.Tag}}" "${IMAGE_NAME}" | egrep -q "^${BASE_TAG}\$"; then
	echo "We appear to have ${BASE_TAG}..."
else
	echo docker pull ${IMAGE_NAME}:${BASE_TAG}
	docker pull ${IMAGE_NAME}:${BASE_TAG} || true
	sleep 2s
fi
if docker images --format "{{.Tag}}" "${IMAGE_NAME}" | egrep -q "^${BASE_TAG}\$"; then
	echo "Skipping ${BASE_TAG}"
else
	docker build \
		--build-arg COMMIT_NAME=${COMMIT_NAME} \
		--build-arg DISTRO_NAME=${DISTRO_NAME} \
		--build-arg DISTRO_VERSION=${DISTRO_VERSION} \
		-t ${IMAGE_NAME}:${BASE_TAG} \
		base
fi


# Programming Fonts Collection

FONTS_TAG="build-fonts-${FONTS_BUILDDATE}"
echo ">> ${IMAGE_NAME}:${FONTS_TAG}"
if docker images --format "{{.Tag}}" "${IMAGE_NAME}" | egrep -q "^${FONTS_TAG}\$"; then
	echo "We appear to have ${FONTS_TAG}..."
else
	echo docker pull ${IMAGE_NAME}:${FONTS_TAG}
	docker pull ${IMAGE_NAME}:${FONTS_TAG} || true
	sleep 2s
fi
if docker images --format "{{.Tag}}" "${IMAGE_NAME}" | egrep -q "^${FONTS_TAG}\$"; then
	echo "Skipping ${FONTS_TAG}"
else
	docker build \
		--build-arg IMAGE_NAME=${IMAGE_NAME} \
		--build-arg COMMIT_NAME=${COMMIT_NAME} \
		--build-arg DISTRO_NAME=${DISTRO_NAME} \
		--build-arg DISTRO_VERSION=${DISTRO_VERSION} \
		-t ${IMAGE_NAME}:${FONTS_TAG} \
		fonts
fi


# Actions on Google

GACTIONS_TAG="build-gactions"
echo ">> ${IMAGE_NAME}:${GACTIONS_TAG}"
if docker images --format "{{.Tag}}" "${IMAGE_NAME}" | egrep -q "^${GACTIONS_TAG}\$"; then
	echo "We appear to have ${GACTIONS_TAG}..."
else
	echo docker pull ${IMAGE_NAME}:${GACTIONS_TAG}
	docker pull ${IMAGE_NAME}:${GACTIONS_TAG} || true
	sleep 2s
fi
if docker images --format "{{.Tag}}" "${IMAGE_NAME}" | egrep -q "^${GACTIONS_TAG}\$"; then
	echo "Skipping ${GACTIONS_TAG}"
else
	docker build \
		--build-arg IMAGE_NAME=${IMAGE_NAME} \
		--build-arg COMMIT_NAME=${COMMIT_NAME} \
		--build-arg DISTRO_NAME=${DISTRO_NAME} \
		--build-arg DISTRO_VERSION=${DISTRO_VERSION} \
		-t ${IMAGE_NAME}:${GACTIONS_TAG} \
		gactions
fi


# Protocol Buffers

PROTOC_TAG="build-protoc${PROTOC_VERSION}-${DISTRO_NAME}${DISTRO_VERSION}"
echo ">> ${IMAGE_NAME}:${PROTOC_TAG}"
if docker images --format "{{.Tag}}" "${IMAGE_NAME}" | egrep -q "^${PROTOC_TAG}\$"; then
	echo "We appear to have ${PROTOC_TAG}..."
else
	echo docker pull ${IMAGE_NAME}:${PROTOC_TAG}
	docker pull ${IMAGE_NAME}:${PROTOC_TAG} || true
	sleep 2s
fi
if docker images --format "{{.Tag}}" "${IMAGE_NAME}" | egrep -q "^${PROTOC_TAG}\$"; then
	echo "Skipping ${PROTOC_TAG}"
else
	docker build \
		--build-arg IMAGE_NAME=${IMAGE_NAME} \
		--build-arg COMMIT_NAME=${COMMIT_NAME} \
		--build-arg DISTRO_NAME=${DISTRO_NAME} \
		--build-arg DISTRO_VERSION=${DISTRO_VERSION} \
		--build-arg PROTOC_VERSION=${PROTOC_VERSION} \
		-t ${IMAGE_NAME}:${PROTOC_TAG} \
		protoc
fi


# Kubernetes Helm

HELM_TAG="build-helm${HELM_VERSION}"
echo ">> ${IMAGE_NAME}:${HELM_TAG}"
if docker images --format "{{.Tag}}" "${IMAGE_NAME}" | egrep -q "^${HELM_TAG}\$"; then
	echo "We appear to have ${HELM_TAG}..."
else
	echo docker pull ${IMAGE_NAME}:${HELM_TAG}
	docker pull ${IMAGE_NAME}:${HELM_TAG} || true
	sleep 2s
fi
if docker images --format "{{.Tag}}" "${IMAGE_NAME}" | egrep -q "^${HELM_TAG}\$"; then
	echo "Skipping ${HELM_TAG}"
else
	docker build \
		--build-arg IMAGE_NAME=${IMAGE_NAME} \
		--build-arg COMMIT_NAME=${COMMIT_NAME} \
		--build-arg DISTRO_NAME=${DISTRO_NAME} \
		--build-arg DISTRO_VERSION=${DISTRO_VERSION} \
		--build-arg HELM_VERSION=${HELM_VERSION} \
		-t ${IMAGE_NAME}:${HELM_TAG} \
		helm
fi


# Go

GO_TAG="build-go${GO_VERSION}"
echo ">> ${IMAGE_NAME}:${GO_TAG}"
if docker images --format "{{.Tag}}" "${IMAGE_NAME}" | egrep -q "^${GO_TAG}\$"; then
	echo "We appear to have ${GO_TAG}..."
else
	echo docker pull ${IMAGE_NAME}:${GO_TAG}
	docker pull ${IMAGE_NAME}:${GO_TAG} || true
	sleep 2s
fi
if docker images --format "{{.Tag}}" "${IMAGE_NAME}" | egrep -q "^${GO_TAG}\$"; then
	echo "Skipping ${GO_TAG}"
else
	docker build \
		--build-arg IMAGE_NAME=${IMAGE_NAME} \
		--build-arg COMMIT_NAME=${COMMIT_NAME} \
		--build-arg DISTRO_NAME=${DISTRO_NAME} \
		--build-arg DISTRO_VERSION=${DISTRO_VERSION} \
		--build-arg GO_VERSION=${GO_VERSION} \
		-t ${IMAGE_NAME}:${GO_TAG} \
		go
fi


# Google App Engine Go SDK

GAESDK_TAG="build-gaesdk${GAESDK_VERSION}"
echo ">> ${IMAGE_NAME}:${GAESDK_TAG}"
if docker images --format "{{.Tag}}" "${IMAGE_NAME}" | egrep -q "^${GAESDK_TAG}\$"; then
	echo "We appear to have ${GAESDK_TAG}..."
else
	echo docker pull ${IMAGE_NAME}:${GAESDK_TAG}
	docker pull ${IMAGE_NAME}:${GAESDK_TAG} || true
	sleep 2s
fi
if docker images --format "{{.Tag}}" "${IMAGE_NAME}" | egrep -q "^${GAESDK_TAG}\$"; then
	echo "Skipping ${GAESDK_TAG}"
else
	docker build \
		--build-arg IMAGE_NAME=${IMAGE_NAME} \
		--build-arg COMMIT_NAME=${COMMIT_NAME} \
		--build-arg DISTRO_NAME=${DISTRO_NAME} \
		--build-arg DISTRO_VERSION=${DISTRO_VERSION} \
		--build-arg GAESDK_VERSION=${GAESDK_VERSION} \
		-t ${IMAGE_NAME}:${GAESDK_TAG} \
		gaesdk
fi


# The Composite Build (no UI)

LATEST_NOUI=
[ -z $NOT_COMMITTED ] && LATEST_NOUI="-t ${IMAGE_NAME}:latest-noui"

echo ">> ${IMAGE_NAME}:${VERSION_NOUI} ${LATEST_NOUI}"

docker build \
	--build-arg IMAGE_NAME=${IMAGE_NAME} \
	--build-arg COMMIT_NAME=${COMMIT_NAME} \
	--build-arg DISTRO_NAME=${DISTRO_NAME} \
	--build-arg DISTRO_VERSION=${DISTRO_VERSION} \
	--build-arg PROTOC_VERSION=${PROTOC_VERSION} \
	--build-arg HELM_VERSION=${HELM_VERSION} \
	--build-arg GO_VERSION=${GO_VERSION} \
	--build-arg GAESDK_VERSION=${GAESDK_VERSION} \
	--build-arg NODE_REPOVER=${NODE_REPOVER} \
	--build-arg MONGO_REPOVER=${MONGO_REPOVER} \
	--build-arg MONGO_DISTRO_NAME=${MONGO_DISTRO_NAME} \
	--build-arg MONGO_SIGNING_KEY=${MONGO_SIGNING_KEY} \
	-t ${IMAGE_NAME}:${VERSION_NOUI} ${LATEST_NOUI} \
	devenv


# The Composite Build (full)

LATEST=
[ -z $NOT_COMMITTED ] && LATEST="-t ${IMAGE_NAME}:latest"

echo ">> ${IMAGE_NAME}:${VERSION_FULL} ${LATEST}"

docker build \
	--build-arg IMAGE_NAME=${IMAGE_NAME} \
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
	--build-arg MONGO_SIGNING_KEY=${MONGO_SIGNING_KEY} \
	-t ${IMAGE_NAME}:${VERSION_FULL} ${LATEST} \
	devenv


# Push!

if [ -z $NOT_COMMITTED ]; then
	docker push ${IMAGE_NAME}:base-${DISTRO_NAME}${DISTRO_VERSION}
	docker push ${IMAGE_NAME}:build-fonts
	docker push ${IMAGE_NAME}:build-gactions
	docker push ${IMAGE_NAME}:build-protoc${PROTOC_VERSION}-${DISTRO_NAME}${DISTRO_VERSION}
	docker push ${IMAGE_NAME}:build-helm${HELM_VERSION}
	docker push ${IMAGE_NAME}:build-go${GO_VERSION}
	docker push ${IMAGE_NAME}:build-gaesdk${GAESDK_VERSION}
	docker push ${IMAGE_NAME}:${VERSION_NOUI}
	docker push ${IMAGE_NAME}:latest-noui
	docker push ${IMAGE_NAME}:${VERSION_FULL}
	docker push ${IMAGE_NAME}:latest
fi
