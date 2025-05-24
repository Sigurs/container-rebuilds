FROM ghcr.io/gchq/cyberchef:latest AS source

FROM nginxinc/nginx-unprivileged AS cyberchef

COPY --from=source /usr/share/nginx/html/ /usr/share/nginx/html/