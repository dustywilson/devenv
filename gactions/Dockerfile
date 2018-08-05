ARG COMMIT_NAME=unknown
ARG IMAGE_NAME=emmaly/devenv
ARG DISTRO_NAME=ubuntu
ARG DISTRO_VERSION=latest


FROM ${IMAGE_NAME}:base-${DISTRO_NAME}${DISTRO_VERSION} AS compiler

RUN curl https://dl.google.com/gactions/updates/bin/linux/amd64/gactions/gactions > /tmp/gactions
RUN chmod 755 /tmp/gactions


FROM scratch

ARG COMMIT_NAME

LABEL maintainer="Emmaly Wilson <emmaly@emma.ly>" \
      description="This image is not directly usable, but is intended as a source for other images.  It contains the Actions on Google binary." \
      commit.name="${COMMIT_NAME}"

COPY --from=compiler /tmp/gactions /usr/bin/gactions
