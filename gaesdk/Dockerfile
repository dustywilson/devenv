ARG COMMIT_NAME=unknown
ARG IMAGE_NAME=emmaly/devenv
ARG DISTRO_NAME=ubuntu
ARG DISTRO_VERSION=latest
ARG GAESDK_VERSION


FROM ${IMAGE_NAME}:base-${DISTRO_NAME}${DISTRO_VERSION} AS compiler

ARG GAESDK_VERSION

WORKDIR /gaesdk
RUN curl https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_linux_amd64-${GAESDK_VERSION}.zip -o /tmp/gaesdk.zip
RUN unzip /tmp/gaesdk.zip


FROM scratch

ARG COMMIT_NAME
ARG GAESDK_VERSION

LABEL maintainer="Emmaly Wilson <emmaly@emma.ly>" \
      description="This image is not directly usable, but is intended as a source for other images.  It contains the Google App Engine Go SDK." \
      commit.name="${COMMIT_NAME}" \
      gaesdk.version="${GAESDK_VERSION}"

COPY --from=compiler /gaesdk /gaesdk
