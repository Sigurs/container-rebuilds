#!/bin/sh
# xvfb-run's SIGUSR1 readiness handshake hangs in this container (it waits for a
# signal Xvfb never sends, so the command never launches). Manage Xvfb directly
# and wait for its socket ourselves instead.
set -e

# A killed container leaves OBS's crash sentinel behind; next boot then shows
# the Safe Mode dialog and hangs headless. Clear it before launch.
# (safe_mode = OBS <= 31, .sentinel/run_* = OBS 32+; --disable-shutdown-check
# was removed in 32 so clearing these is the only way.)
rm -rf /home/obs/.config/obs-studio/safe_mode /home/obs/.config/obs-studio/.sentinel

# Same story for CEF: a hard stop leaves Chromium's SingletonLock (a
# hostname+pid symlink) in the browser profile; the recreated container has a
# new hostname, so CEF sees "profile in use by another computer" and dies with
# exit code 21. Clear it before launch.
rm -f /home/obs/.config/obs-studio/plugin_config/obs-browser/Singleton*

DISPLAY_NUM=99
export DISPLAY=":${DISPLAY_NUM}"
SCREEN="${OBS_SCREEN:-1920x1080x24}"

mkdir -p /tmp/.X11-unix

# A hard stop leaves the lock/socket behind; if /tmp persists, Xvfb refuses to
# reuse the display. Clear our own stale files before (re)starting.
rm -f "/tmp/.X${DISPLAY_NUM}-lock" "/tmp/.X11-unix/X${DISPLAY_NUM}"

Xvfb "$DISPLAY" -screen 0 "$SCREEN" -nolisten tcp &
XVFB_PID=$!

# Wait for the X socket before starting anything that needs the display.
for _ in $(seq 1 50); do
    [ -S "/tmp/.X11-unix/X${DISPLAY_NUM}" ] && break
    kill -0 "$XVFB_PID" 2>/dev/null || { echo "Xvfb exited during startup" >&2; exit 1; }
    sleep 0.1
done

# ponytail: -nopw, fine for a LAN/dev container. Set VNC_PASSWORD to require one.
if [ -n "$VNC_PASSWORD" ]; then
    AUTH="-passwd $VNC_PASSWORD"
else
    AUTH="-nopw"
fi

x11vnc -display "$DISPLAY" -forever -shared -rfbport 5900 -listen 0.0.0.0 $AUTH &

# FFmpeg logs straight to stderr with no level control; the media source
# retrying a not-yet-published RTSP stream spams DESCRIBE 404s. Filter them
# out via a fifo so exec is preserved (obs keeps PID 1 signal handling).
FIFO=/tmp/obs-stderr
rm -f "$FIFO"
mkfifo "$FIFO"
grep -v --line-buffered 'method DESCRIBE failed' < "$FIFO" >&2 &

exec obs --disable-shutdown-check 2> "$FIFO"
