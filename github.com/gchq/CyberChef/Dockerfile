FROM ghcr.io/gchq/cyberchef:latest as source

FROM nginxinc/nginx-unprivileged as cyberchef

COPY --from=source /usr/share/nginx/html/ /usr/share/nginx/html/