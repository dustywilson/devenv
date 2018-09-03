ARG COMMIT_NAME=unknown
ARG IMAGE_NAME=emmaly/devenv
ARG DISTRO_NAME=ubuntu
ARG DISTRO_VERSION=latest
ARG FONTS_BUILDDATE
ARG GACTIONS_BUILDDATE
ARG PROTOC_VERSION
ARG HELM_VERSION
ARG GO_VERSION
ARG ATOM_VERSION
ARG VSCODE_VERSION
ARG VSCODE_SHA256
ARG GAESDK_VERSION
ARG NODE_REPOVER
ARG MONGO_REPOVER
ARG MONGO_DISTRO_NAME
ARG MONGO_SIGNING_KEY


FROM ${IMAGE_NAME}:build-fonts-${FONTS_BUILDDATE} AS fonts
FROM ${IMAGE_NAME}:build-gactions-${GACTIONS_BUILDDATE} AS gactions
FROM ${IMAGE_NAME}:build-protoc${PROTOC_VERSION}-${DISTRO_NAME}${DISTRO_VERSION} AS protoc
FROM ${IMAGE_NAME}:build-helm${HELM_VERSION} AS helm
FROM ${IMAGE_NAME}:build-go${GO_VERSION} AS go
FROM ${IMAGE_NAME}:build-gaesdk${GAESDK_VERSION} AS gaesdk


FROM ${IMAGE_NAME}:base-${DISTRO_NAME}${DISTRO_VERSION}
ARG DISTRO_NAME

# User Setup
RUN useradd -d /user -m user
WORKDIR /user

# Node.js Repo & Keys
ARG NODE_REPOVER
RUN curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
	echo "deb https://deb.nodesource.com/node_${NODE_REPOVER} $(lsb_release -c -s) main" > /etc/apt/sources.list.d/nodesource.list && \
	echo "deb-src https://deb.nodesource.com/node_${NODE_REPOVER} $(lsb_release -c -s) main" >> /etc/apt/sources.list.d/nodesource.list

# MongoDB Repo & Keys
ARG MONGO_REPOVER
ARG MONGO_DISTRO_NAME
ARG MONGO_SIGNING_KEY
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv ${MONGO_SIGNING_KEY} && \
	echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/${DISTRO_NAME} ${MONGO_DISTRO_NAME}/mongodb-org/${MONGO_REPOVER} multiverse" > /etc/apt/sources.list.d/mongodb-org-${MONGO_REPOVER}.list

# Yarn Repo & Keys
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
	echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list

# Needed packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
	bash-completion \
	bzr \
	dnsutils \
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
	libgtk-3-0 \
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
	ssh-client \
	telnet \
	vim \
	whois \
	xdg-utils \
	yarn && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# A lovely collection of programming fonts
COPY --from=fonts /fonts /usr/share/fonts
RUN fc-cache -f

# Actions on Google
COPY --from=gactions /usr/bin /usr/bin

# Protocol Buffers
COPY --from=protoc /usr /usr

# Kubernetes Helm
COPY --from=helm /helm /usr/bin/helm

# Go
COPY --from=go /usr/local /usr/local
RUN chown -R user:user /usr/local/go/pkg
RUN mkdir -p /user/go/src
VOLUME ["/user/go"]

# Google App Engine SDK
COPY --from=gaesdk /gaesdk /user/go_appengine
RUN chown -R user:user /user/go_appengine

# User Switch
USER user

# npm and yarn Configuration
RUN mkdir /user/.npm-global && \
	npm config set prefix /user/.npm-global && \
	echo 'PATH="$PATH":/user/.npm-global/bin' >> /user/.bashrc
RUN mkdir /user/.yarn && \
	yarn config set prefix /user/.yarn && \
	echo 'PATH="$PATH":/user/.yarn/bin' >> /user/.bashrc

# Install packages via yarn
RUN yarn global add bower
RUN yarn global add localtunnel
RUN yarn global add polymer-cli
RUN yarn global add firebase-tools
RUN yarn global add webpack webpack-cli

# User Switch
USER root

# Atom
ARG ATOM_VERSION
ENV ATOM_VERSION=${ATOM_VERSION}
RUN if test ! -z "${ATOM_VERSION}"; then \
		curl -L https://github.com/atom/atom/releases/download/v${ATOM_VERSION}/atom-amd64.deb > /tmp/atom.deb && \
		dpkg -i /tmp/atom.deb && \
		rm /tmp/atom.deb; \
	fi

# VS Code
ARG VSCODE_VERSION
ARG VSCODE_SHA256
ENV VSCODE_VERSION=${VSCODE_VERSION}
ENV VSCODE_SHA256=${VSCODE_SHA256:-.}
RUN if test ! -z "${VSCODE_VERSION}"; then \
		curl -L https://vscode-update.azurewebsites.net/${VSCODE_VERSION}/linux-deb-x64/stable > /tmp/vscode.deb && \
		sha256sum /tmp/vscode.deb | grep -q "${VSCODE_SHA256}" && \
		dpkg -i /tmp/vscode.deb && \
		rm /tmp/vscode.deb; \
	fi

# User Switch
USER user

# yarn bin storage workaround
RUN mkdir -p /user/.yarn && \
	mv /user/.config/yarn/global /user/.yarn/global && \
	ln -s ../../.yarn/global /user/.config/yarn/global && \
	echo "mkdir -p /user/.config/yarn && [ ! -e /user/.config/yarn/global ] && ln -s ../../.yarn/global /user/.config/yarn/global" >> /user/.bashrc

# Setup bash autocomplete
RUN echo "source <("kubectl" completion bash); source <("helm" completion bash)" >> /user/.bashrc

# Setup ssh key and custom .profile
RUN echo "eval \$(ssh-agent)\nssh-add" >> /user/.bashrc
RUN echo "[[ -f /user/.config/.profile ]] && source /user/.config/.profile" >> /user/.bashrc

# Entrypoint!
COPY example.sh /user/example.sh
COPY entrypoint.sh /user/entrypoint.sh
ENTRYPOINT ["/user/entrypoint.sh"]

# Labels
ARG COMMIT_NAME
ARG DISTRO_NAME
ARG DISTRO_VERSION
ARG PROTOC_VERSION
ARG HELM_VERSION
ARG GO_VERSION
ARG GAESDK_VERSION
LABEL maintainer="Emmaly Wilson <emmaly@emma.ly>" \
      description="Pure development bliss." \
      commit.name="${COMMIT_NAME}" \
      fonts.builddate="${FONTS_BUILDDATE}" \
      gactions.builddate="${GACTIONS_BUILDDATE}" \
      protoc.version="${PROTOC_VERSION}" \
      helm.version="${HELM_VERSION}" \
      go.version="${GO_VERSION}" \
      atom.version="${ATOM_VERSION}" \
      vscode.linkid="${VSCODE_VERSION}" \
      gaesdk.version="${GAESDK_VERSION}" \
      node.repover="${NODE_REPOVER}" \
      mongo.repover="${MONGO_REPOVER}" \
      builddistro.name="${DISTRO_NAME}" \
      builddistro.version="${DISTRO_VERSION}"
