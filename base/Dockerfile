ARG COMMIT_NAME=unknown
ARG DISTRO_NAME=ubuntu
ARG DISTRO_VERSION=latest


FROM ${DISTRO_NAME}:${DISTRO_VERSION}

# Bare Essentials
RUN apt-get update && apt-get install --no-install-recommends -y \
	apt-transport-https \
	ca-certificates \
	curl \
	dirmngr \
	fakeroot \
	git \
	lsb-release \
	unzip && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Google Cloud SDK
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
	echo "deb http://packages.cloud.google.com/apt cloud-sdk-$(lsb_release -c -s) main" > /etc/apt/sources.list.d/google-cloud-sdk.list && \
	apt-get update && apt-get install --no-install-recommends -y google-cloud-sdk && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

ARG COMMIT_NAME
ARG DISTRO_NAME
ARG DISTRO_VERSION

LABEL maintainer="Dusty Wilson <dusty@linux.com>" \
      description="This image is intended to provide ${DISTRO_NAME}:${DISTRO_VERSION} plus bare essentials, such as curl and git." \
      commit.name="${COMMIT_NAME}" \
      builddistro.name="${DISTRO_NAME}" \
      builddistro.version="${DISTRO_VERSION}"
