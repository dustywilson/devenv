ARG COMMIT_NAME=unknown
ARG IMAGE_NAME=dustywilson/devenv
ARG DISTRO_NAME=ubuntu
ARG DISTRO_VERSION=latest
ARG GO_VERSION


FROM ${IMAGE_NAME}:base-${DISTRO_NAME}${DISTRO_VERSION} AS compiler

ARG GO_VERSION

RUN gsutil cp gs://golang/go${GO_VERSION}.linux-amd64.tar.gz /tmp/go.tgz
RUN tar -C /usr/local -zxf /tmp/go.tgz


FROM scratch

ARG COMMIT_NAME
ARG GO_VERSION

LABEL maintainer="Dusty Wilson <dusty@linux.com>" \
      description="This image is not directly usable, but is intended as a source for other images.  It contains the Go programming language." \
      commit.name="${COMMIT_NAME}" \
      go.version="${GO_VERSION}"

COPY --from=compiler /usr/local /usr/local
