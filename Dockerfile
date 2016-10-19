FROM anapsix/alpine-java:8_jdk
MAINTAINER Dave Yarwood <dave@adzerk.com>

# SSL support for wget
RUN apk --no-cache add openssl

# boot-clj
RUN apk upgrade --update && \
    apk add --update
RUN wget -O /usr/bin/boot https://github.com/boot-clj/boot-bin/releases/download/latest/boot.sh \
    && chmod +x /usr/bin/boot

ENV BOOT_HOME /.boot
ENV BOOT_AS_ROOT yes
ENV BOOT_LOCAL_REPO /m2

# download & install deps, cache REPL and web deps
RUN /usr/bin/boot web -s doesnt/exist repl -e '(System/exit 0)' && rm -rf target
ADD . /app
WORKDIR /app

ENTRYPOINT ["/usr/bin/boot"]
