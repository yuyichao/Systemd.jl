FROM base/archlinux

RUN pacman --noconfirm -Syu
RUN pacman --noconfirm -S base-devel
RUN pacman --noconfirm -S lsb-release cmake mbedtls xdelta3 http-parser

ENV JULIA_PATH /usr/local/julia
ARG JULIA_VERSION=nightly

ADD download_julia.sh /download_julia.sh

RUN bash -e /download_julia.sh "$JULIA_PATH" "$JULIA_VERSION"

ENV PATH $JULIA_PATH/bin:$PATH

CMD ["julia"]
