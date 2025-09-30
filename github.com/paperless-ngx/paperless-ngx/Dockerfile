ARG IMAGE_TAG=latest

FROM ghcr.io/paperless-ngx/paperless-ngx:${IMAGE_TAG} AS final

RUN apt-get update && \
    apt-get install -y --no-install-recommends tesseract-ocr-fin && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

