ARG COMMIT_NAME=unknown
ARG IMAGE_NAME=dustywilson/devenv
ARG DISTRO_NAME=ubuntu
ARG DISTRO_VERSION=latest
ARG HELM_VERSION


FROM ${IMAGE_NAME}:base-${DISTRO_NAME}${DISTRO_VERSION} AS compiler

ARG HELM_VERSION

RUN curl https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar -zxOf- linux-amd64/helm > /helm
RUN chmod 755 /helm


FROM scratch

ARG COMMIT_NAME
ARG HELM_VERSION

LABEL maintainer="Dusty Wilson <dusty@linux.com>" \
      description="This image is not directly usable, but is intended as a source for other images.  It contains the Kubernetes Helm binary." \
      commit.name="${COMMIT_NAME}" \
      helm.version="${HELM_VERSION}"

COPY --from=compiler /helm /helm
