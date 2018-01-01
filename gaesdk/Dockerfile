ARG COMMIT_NAME=unknown
ARG IMAGE_NAME=dustywilson/devenv
ARG DISTRO_NAME=ubuntu
ARG DISTRO_VERSION=latest
ARG GAESDK_VERSION


FROM ${IMAGE_NAME}:base-${DISTRO_NAME}${DISTRO_VERSION} AS compiler

WORKDIR /gaesdk
RUN gsutil cp gs://appengine-sdks/featured/go_appengine_sdk_linux_amd64-${GAESDK_VERSION}.zip | unzip


FROM scratch

ARG COMMIT_NAME
ARG GAESDK_VERSION

LABEL maintainer="Dusty Wilson <dusty@linux.com>" \
      description="This image is not directly usable, but is intended as a source for other images.  It contains the Google App Engine Go SDK." \
      commit.name="${COMMIT_NAME}" \
      gaesdk.version="${GAESDK_VERSION}"

COPY --from=compiler /gaesdk /gaesdk
