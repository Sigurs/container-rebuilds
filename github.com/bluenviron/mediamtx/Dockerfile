# Pass the release tag (e.g. v1.19.2); the workflow feeds it from latest.txt.
ARG VERSION=v1.19.2

FROM alpine:3 AS build
ARG VERSION
RUN apk add --no-cache curl
WORKDIR /mediamtx
# Upstream ships a static Go build plus the default config; grab it instead of compiling.
RUN curl -fsSL "https://github.com/bluenviron/mediamtx/releases/download/${VERSION}/mediamtx_${VERSION}_linux_amd64.tar.gz" \
    | tar xz -C /mediamtx

FROM alpine:3 AS final
# ca-certificates: MediaMTX talks HTTPS for HLS, WebRTC ICE and remote auth.
# ffmpeg: for runOnDemand/runOnReady transcoding and recording hooks.
# grep: GNU grep for --line-buffered log filtering (busybox grep buffers).
RUN apk add --no-cache ca-certificates ffmpeg grep && adduser -D -H -u 1000 mediamtx
COPY --from=build /mediamtx/mediamtx /usr/local/bin/mediamtx
# Default config; override by mounting your own at /mediamtx.yml.
# chown so the runtime user can rewrite PLACEHOLDER_* in place.
COPY --from=build --chown=mediamtx /mediamtx/mediamtx.yml /mediamtx.yml
COPY --chmod=755 scripts/substitute-env.sh /usr/local/bin/substitute-env.sh
COPY --chmod=755 github.com/bluenviron/mediamtx/start-mediamtx.sh /usr/local/bin/start-mediamtx.sh
USER mediamtx
ENTRYPOINT ["/usr/local/bin/start-mediamtx.sh"]
