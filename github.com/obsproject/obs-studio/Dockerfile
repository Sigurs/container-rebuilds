FROM ubuntu:26.04 AS final

ENV DEBIAN_FRONTEND=noninteractive

# obs-studio from the upstream PPA; xvfb so it can launch headless
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        software-properties-common && \
    add-apt-repository -y ppa:obsproject/obs-studio && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        obs-studio \
        xvfb && \
    apt-get purge -y software-properties-common && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Non-root: OBS writes its config to ~/.config/obs-studio, so give it a home
RUN useradd --create-home --shell /usr/sbin/nologin obs
USER obs
WORKDIR /home/obs

# Launch OBS inside a virtual framebuffer
ENTRYPOINT ["xvfb-run", "-a", "obs"]
