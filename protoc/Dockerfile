ARG DISTRO_NAME=ubuntu
ARG DISTRO_VERSION=latest
ARG PROTOC_VERSION


FROM ${DISTRO_NAME}:${DISTRO_VERSION} as compiler

RUN apt-get update && apt-get install --no-install-recommends -y \
	autoconf \
	automake \
	ca-certificates \
	curl \
	g++ \
	git \
	libtool \
	make \
	unzip && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

ARG PROTOC_VERSION

WORKDIR /tmp/protoc
RUN git clone --depth=1 -b v${PROTOC_VERSION} https://github.com/google/protobuf .
RUN ./autogen.sh
RUN ./configure --prefix=/build
RUN make -j$(nproc)
RUN make check
RUN make install
RUN ldconfig


FROM scratch

ARG DISTRO_NAME
ARG DISTRO_VERSION
ARG PROTOC_VERSION

LABEL maintainer="Dusty Wilson <dusty@linux.com>" \
      description="This image is not directly usable, but is intended as a source for other images.  It contains the compiled binary and libraries for protoc ${PROTOC_VERSION}." \
      protoc.version="${PROTOC_VERSION}" \
      builddistro.name="${DISTRO_NAME}" \
      builddistro.version="${DISTRO_VERSION}"

COPY --from=compiler /build /usr
