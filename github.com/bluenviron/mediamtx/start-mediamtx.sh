#!/bin/sh
set -e

# Fill in PLACEHOLDER_* from env vars; aborts startup if one is unset.
substitute-env.sh /mediamtx.yml

# The API poller asks for paths that aren't live yet; mediamtx logs every 404
# at ERR with no config to silence it. Filter via a fifo so exec is preserved
# (mediamtx keeps PID 1 signal handling for graceful shutdown).
FIFO=/tmp/mediamtx-log
rm -f "$FIFO"
mkfifo "$FIFO"
grep -v --line-buffered 'ERR \[API\] path not found' < "$FIFO" &

exec mediamtx /mediamtx.yml > "$FIFO" 2>&1
