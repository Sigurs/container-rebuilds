#!/bin/sh
# Runs under xvfb-run, so DISPLAY + XAUTHORITY are already set for us.
# Serve that framebuffer over VNC, then hand off to OBS.
# ponytail: -nopw, fine for a LAN/dev container. Set VNC_PASSWORD to require one.
set -e

if [ -n "$VNC_PASSWORD" ]; then
    AUTH="-passwd $VNC_PASSWORD"
else
    AUTH="-nopw"
fi

x11vnc -display "$DISPLAY" -forever -shared -rfbport 5900 -listen 0.0.0.0 $AUTH &

exec obs
