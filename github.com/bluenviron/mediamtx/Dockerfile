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
RUN apk add --no-cache ca-certificates ffmpeg && adduser -D -H -u 1000 mediamtx
COPY --from=build /mediamtx/mediamtx /usr/local/bin/mediamtx
# Default config; override by mounting your own at /mediamtx.yml.
COPY --from=build /mediamtx/mediamtx.yml /mediamtx.yml
USER mediamtx
ENTRYPOINT ["mediamtx", "/mediamtx.yml"]
