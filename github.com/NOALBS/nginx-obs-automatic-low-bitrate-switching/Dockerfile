# Pass the release tag (e.g. v2.18.0); the workflow feeds it from latest.txt.
ARG VERSION=v2.18.0

FROM alpine:3 AS build
ARG VERSION
RUN apk add --no-cache curl
WORKDIR /noalbs
# Upstream ships a static musl build; grab it instead of compiling Rust.
RUN curl -fsSL "https://github.com/NOALBS/nginx-obs-automatic-low-bitrate-switching/releases/download/${VERSION}/noalbs-${VERSION}-x86_64-unknown-linux-musl.tar.gz" \
    | tar xz --strip-components=1 -C /noalbs

FROM alpine:3 AS final
# ca-certificates: NOALBS talks HTTPS to Twitch/Kick and stats servers.
RUN apk add --no-cache ca-certificates && adduser -D -H -u 1000 noalbs
COPY --from=build /noalbs/noalbs /usr/local/bin/noalbs
# NOALBS reads config.json from the working dir; mount yours at /config.
WORKDIR /config
USER noalbs
ENTRYPOINT ["noalbs"]
