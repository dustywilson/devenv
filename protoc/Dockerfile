ARG COMMIT_NAME=unknown
ARG IMAGE_NAME=emmaly/devenv
ARG DISTRO_NAME=ubuntu
ARG DISTRO_VERSION=latest
ARG PROTOC_VERSION


FROM ${IMAGE_NAME}:base-${DISTRO_NAME}${DISTRO_VERSION} AS compiler

RUN apt-get update && apt-get install --no-install-recommends -y \
	autoconf \
	automake \
	g++ \
	libtool \
	make && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

ARG PROTOC_VERSION

WORKDIR /tmp/protoc
RUN git clone --depth=1 -b v${PROTOC_VERSION} https://github.com/google/protobuf .
RUN ./autogen.sh
RUN ./configure --prefix=/build
RUN make -j$(nproc)
#RUN make check
RUN make install
RUN ldconfig


FROM scratch

ARG COMMIT_NAME
ARG DISTRO_NAME
ARG DISTRO_VERSION
ARG PROTOC_VERSION

LABEL maintainer="Emmaly Wilson <emmaly@emma.ly>" \
      description="This image is not directly usable, but is intended as a source for other images.  It contains the compiled binary and libraries for protoc ${PROTOC_VERSION}." \
      commit.name="${COMMIT_NAME}" \
      protoc.version="${PROTOC_VERSION}" \
      builddistro.name="${DISTRO_NAME}" \
      builddistro.version="${DISTRO_VERSION}"

COPY --from=compiler /build /usr
