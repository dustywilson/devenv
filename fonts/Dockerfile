ARG COMMIT_NAME=unknown
ARG IMAGE_NAME=dustywilson/devenv
ARG DISTRO_NAME=ubuntu
ARG DISTRO_VERSION=latest


FROM ${IMAGE_NAME}:base-${DISTRO_NAME}${DISTRO_VERSION} AS compiler

WORKDIR /fonts

# Google Fonts
WORKDIR /fonts/google-cloud-fonts
RUN curl -L https://github.com/google/fonts/archive/master.zip > /tmp/googlefonts.zip
RUN unzip -q /tmp/googlefonts.zip

# Go Font
WORKDIR /fonts/gofont
RUN git clone --depth=1 https://go.googlesource.com/image /tmp/go-image
RUN cp /tmp/go-image/font/gofont/ttfs/*.ttf .

# FiraCode Font
WORKDIR /fonts/firacode
RUN git clone --depth=1 https://github.com/tonsky/FiraCode.git /tmp/firacode
RUN cp /tmp/firacode/distr/ttf/*.ttf .


FROM scratch

ARG COMMIT_NAME

LABEL maintainer="Dusty Wilson <dusty@linux.com>" \
      description="This image is not directly usable, but is intended as a source for other images.  It contains a lovely compilation of programmer-friendly fonts." \
      commit.name="${COMMIT_NAME}"

COPY --from=compiler /fonts /fonts
