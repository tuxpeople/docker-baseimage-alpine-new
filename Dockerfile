# Runtime stage
FROM docker.io/library/alpine:3.18

# renovate: datasource=repology depName=alpine_3_18/iptables versioning=loose
ENV iptables_pkgversion="1.8.9-r2"
# renovate: datasource=repology depName=alpine_3_18/busybox versioning=loose
ENV busybox_pkgversion="1.36.1-r5"
# renovate: datasource=repology depName=alpine_3_18/bash versioning=loose
ENV bash_pkgversion="5.2.15-r5"
# renovate: datasource=repology depName=alpine_3_18/bind-tools versioning=loose
ENV bind-tools_pkgversion="9.18.19-r0"
# renovate: datasource=repology depName=alpine_3_18/ca-certificates versioning=loose
ENV ca-certificates_pkgversion="20230506-r0"
# renovate: datasource=repology depName=alpine_3_18/coreutils versioning=loose
ENV coreutils_pkgversion="9.3-r1"
# renovate: datasource=repology depName=alpine_3_18/curl versioning=loose
ENV curl_pkgversion="8.4.0-r0"
# renovate: datasource=repology depName=alpine_3_18/jq versioning=loose
ENV jq_pkgversion="1.6-r3"
# renovate: datasource=repology depName=alpine_3_18/moreutils versioning=loose
ENV moreutils_pkgversion="0.67-r0"
# renovate: datasource=repology depName=alpine_3_18/nano versioning=loose
ENV nano_pkgversion="7.2-r1"
# renovate: datasource=repology depName=alpine_3_18/netcat-openbsd versioning=loose
ENV netcat-openbsd_pkgversion="1.219-r1"
# renovate: datasource=repology depName=alpine_3_18/shadow versioning=loose
ENV shadow_pkgversion="4.13-r4"
# renovate: datasource=repology depName=alpine_3_18/tini versioning=loose
ENV tini_pkgversion="0.19.0-r1"
# renovate: datasource=repology depName=alpine_3_18/tzdata versioning=loose
ENV tzdata_pkgversion="2023c-r1"
# renovate: datasource=repology depName=alpine_3_18/unzip versioning=loose
ENV unzip_pkgversion="6.0-r9"
# renovate: datasource=repology depName=alpine_3_18/util-linux versioning=loose
ENV util-linux_pkgversion="2.38.1-r8"
# renovate: datasource=repology depName=alpine_3_18/wget versioning=loose
ENV wget_pkgversion="1.21.4-r0"

# environment variables
ENV PS1="$(whoami)@$(hostname):$(pwd)\\$ " \
    HOME="/root" \
    TERM="xterm"

SHELL ["/bin/ash", "-o", "pipefail", "-c"]


# hadolint ignore=DL3018
RUN \
    echo "**** install runtime packages ****" && \
    PACKAGES=""; for PKG in "$(env | grep _pkgversion | sed 's/_pkgversion//g')"; do PACKAGES="${PACKAGES} ${PKG}" ; done && \
    apk add --no-cache ${PACKAGES} || exit 1 && \
    echo "**** create abc user and make our folders ****" && \
    groupmod -g 1000 users && \
    useradd -u 911 -U -d /config -s /bin/false abc && \
    usermod -G users abc && \
    sed -i -e 's/^root::/root:!:/' /etc/shadow; mkdir -p \
    /app \
    /config \
    /defaults && \
    echo "**** cleanup ****" && \
    rm -rf \
    /tmp/*

# add local files
COPY root/ /

ENTRYPOINT ["/sbin/tini", "--"]