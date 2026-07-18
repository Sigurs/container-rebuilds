ARG IMAGE_TAG=latest

FROM ghcr.io/gchq/cyberchef:${IMAGE_TAG} AS source

FROM nginxinc/nginx-unprivileged:1 AS final

COPY --from=source /usr/share/nginx/html/ /usr/share/nginx/html/
