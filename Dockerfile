FROM debian:12.14-slim

ENV DEBIAN_FRONTEND=noninteractive \
    INSTALL_DIR=/data

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    set -eux; \
    dpkg --add-architecture i386; \
    sed -i 's/Components: main/Components: main non-free non-free-firmware/g' \
        /etc/apt/sources.list.d/debian.sources; \
    echo steam steam/question select "I AGREE" | debconf-set-selections; \
    apt-get update; \
    apt-get install -y \
        ca-certificates \
        locales \
        steamcmd \
        procps \
        rsync \
        tzdata \
    ; \
    apt-get autoclean

RUN set -eux; \
    sed -ri 's/^# (en_US.UTF-8 UTF-8)$/\1/' /etc/locale.gen; \
    locale-gen en_US.UTF-8; \
    dpkg-reconfigure locales

RUN set -eux; \
    groupadd -g 1000 steam; \
    useradd -m -u 1000 -g steam -s /bin/bash steam

COPY --chmod=0755 entrypoint.sh /

USER steam:steam

WORKDIR /data

STOPSIGNAL SIGINT
ENTRYPOINT [ "/entrypoint.sh" ]
