FROM ghcr.io/gchq/cyberchef:latest AS source

FROM nginxinc/nginx-unprivileged AS final

COPY --from=source /usr/share/nginx/html/ /usr/share/nginx/html/