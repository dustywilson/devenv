ARG COMMIT_NAME=unknown
ARG IMAGE_NAME=dustywilson/devenv
ARG DISTRO_NAME=ubuntu
ARG DISTRO_VERSION=latest
ARG PROTOC_VERSION
ARG HELM_VERSION
ARG GO_VERSION
ARG ATOM_VERSION
ARG GAESDK_VERSION
ARG NODE_REPOVER
ARG MONGO_REPOVER
ARG MONGO_DISTRO_NAME


FROM ${IMAGE_NAME}:build-fonts AS fonts
FROM ${IMAGE_NAME}:build-gactions AS gactions
FROM ${IMAGE_NAME}:build-protoc${PROTOC_VERSION} AS protoc
FROM ${IMAGE_NAME}:build-helm${HELM_VERSION} AS helm
FROM ${IMAGE_NAME}:build-go${GO_VERSION} AS go
FROM ${IMAGE_NAME}:build-gaesdk${GAESDK_VERSION} AS gaesdk


FROM ${IMAGE_NAME}:base-${DISTRO_NAME}${DISTRO_VERSION}

ARG NODE_REPOVER
ARG MONGO_REPOVER
ARG MONGO_DISTRO_NAME

# User Setup
RUN useradd -d /user -m user
WORKDIR /user

# Node.js Repo & Keys
RUN curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
	echo "deb https://deb.nodesource.com/node_${NODE_REPOVER} $(lsb_release -c -s) main" > /etc/apt/sources.list.d/nodesource.list && \
	echo "deb-src https://deb.nodesource.com/node_${NODE_REPOVER} $(lsb_release -c -s) main" >> /etc/apt/sources.list.d/nodesource.list && \

# MongoDB Repo & Keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 && \
	echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt ${MONGO_DISTRO_NAME}/mongodb-org/${MONGO_REPOVER} multiverse" | tee /etc/apt/sources.list.d/mongodb-org-${MONGO_REPOVER}.list

# Needed packages
RUN apt-get update && apt-get install --no-install-recommends -y \
	bash-completion \
	bzr \
	g++ \
	gconf2 \
	gconf-service \
	gvfs-bin \
	inotify-tools \
	iputils-ping \
	konsole \
	kubectl \
	libasound2 \
	libcap2 \
	libgconf-2-4 \
	libgtk2.0-0 \
	libnotify4 \
	libnss3 \
	libx11-xcb1 \
	libxkbfile1 \
	libxss1 \
	libxtst6 \
	mongodb-org-shell \
	mongodb-org-mongos \
	mongodb-org-tools \
	nano \
	nodejs \
	python \
	ssh \
	telnet \
	vim \
	xdg-utils && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

ARG COMMIT_NAME
ARG DISTRO_NAME
ARG DISTRO_VERSION
ARG PROTOC_VERSION
ARG HELM_VERSION
ARG GO_VERSION
ARG GAESDK_VERSION

LABEL maintainer="Dusty Wilson <dusty@linux.com>" \
      description="Pure development bliss." \
      commit.name="${COMMIT_NAME}" \
      protoc.version="${PROTOC_VERSION}" \
      helm.version="${HELM_VERSION}" \
      go.version="${GO_VERSION}" \
      atom.version="${ATOM_VERSION}" \
      gaesdk.version="${GAESDK_VERSION}" \
      node.repover="${NODE_REPOVER}" \
      mongo.repover="${MONGO_REPOVER}" \
      builddistro.name="${DISTRO_NAME}" \
      builddistro.version="${DISTRO_VERSION}"

# A lovely collection of programming fonts
COPY --from=fonts /fonts /usr/share/fonts
RUN fc-cache -f

# Actions on Google
COPY --from=gactions /usr/bin /usr/bin

# Protocol Buffers
COPY --from=protoc /usr /usr

# Kubernetes Helm
COPY --from=helm /helm /usr/bin

# Go
COPY --from=go /usr/local /usr/local
RUN chown -R user:user /usr/local/go/pkg
RUN mkdir -p /user/go/src
VOLUME ["/user/go"]

# Atom
RUN curl -L https://github.com/atom/atom/releases/download/v${ATOM_VERSION}/atom-amd64.deb > /tmp/atom.deb && \
	dpkg -i /tmp/atom.deb && \
	rm /tmp/atom.deb

# Google App Engine SDK
COPY --from=gaesdk /gaesdk /user/go_appengine
RUN chown -R user:user /user/go_appengine

# User Switch
USER user

# npm Configuration
RUN mkdir /user/.npm-global && \
	npm config set prefix /user/.npm-global && \
	echo 'PATH="$PATH":/user/.npm-global/bin' >> /user/.profile

# Install packages via npm
RUN npm install --global bower
RUN npm install --global yarn
RUN npm install --global localtunnel
RUN npm install --global polymer-cli
RUN npm install --global firebase-tools

# Setup bash autocomplete
RUN echo "source <("kubectl" completion bash); source <("helm" completion bash)" >> /user/.bashrc

# Entrypoint!
COPY entrypoint.sh /user/entrypoint.sh
ENTRYPOINT ["/user/entrypoint.sh"]