#!/bin/sh
# Replace occurrences of each PLACEHOLDER_* env var name (e.g. PLACEHOLDER_DB_PASSWORD)
# in the given files/dirs with that variable's value.
# Exits non-zero if a PLACEHOLDER_ var is set but empty.
set -eu

for target in "$@"; do
    [ -e "$target" ] || echo "substitute-env: $target does not exist, skipping" >&2
done

# Longest names first (sort -r) so PLACEHOLDER_DB never clobbers PLACEHOLDER_DB_USER.
env | grep -oE '^PLACEHOLDER_[A-Za-z0-9_]+' | sort -ur | while read -r token; do
    eval "val=\${$token-}"
    if [ -z "$val" ]; then
        echo "substitute-env: $token is set but empty" >&2
        exit 1
    fi
    # Escape sed replacement special chars: \ & /
    escaped=$(printf '%s' "$val" | sed 's/[&/\\]/\\&/g')
    for target in "$@"; do
        [ -e "$target" ] || continue
        grep -rlF "$token" "$target" | while read -r f; do
            tmp=$(mktemp)
            sed "s/$token/$escaped/g" "$f" > "$tmp"
            cat "$tmp" > "$f" # rewrite in place: works even when the parent dir is read-only (e.g. /)
            rm -f "$tmp"
        done
    done
done

# Fail if any placeholder survived (no matching env var was set).
leftover=0
for target in "$@"; do
    [ -e "$target" ] || continue
    if grep -rnoE 'PLACEHOLDER_[A-Za-z0-9_]+' "$target" >&2; then
        leftover=1
    fi
done
if [ "$leftover" -ne 0 ]; then
    echo "substitute-env: unreplaced placeholders remain (listed above)" >&2
    exit 1
fi
