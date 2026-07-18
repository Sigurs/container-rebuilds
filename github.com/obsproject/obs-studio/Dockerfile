FROM ubuntu:26.04 AS final

ENV DEBIAN_FRONTEND=noninteractive

# obs-studio from the upstream PPA; xvfb + x11vnc so it can run headless and be
# viewed over VNC
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        software-properties-common && \
    add-apt-repository -y ppa:obsproject/obs-studio && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        obs-studio \
        qt6-svg-plugins \
        xvfb \
        x11vnc && \
    apt-get purge -y software-properties-common && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --chmod=755 github.com/obsproject/obs-studio/start-obs.sh /usr/local/bin/start-obs.sh

# Non-root: OBS writes its config to ~/.config/obs-studio, so give it a home
RUN userdel --remove $(id -un 1000) 2>/dev/null; \
    useradd --create-home --uid 1000 --shell /usr/sbin/nologin obs
USER obs
WORKDIR /home/obs

# VNC server for the virtual framebuffer
EXPOSE 5900

# Launch OBS inside a virtual framebuffer, exposed over VNC on :5900
ENTRYPOINT ["/usr/local/bin/start-obs.sh"]
