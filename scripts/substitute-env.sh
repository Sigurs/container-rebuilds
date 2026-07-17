#!/bin/sh
# Replace PLACEHOLDER_<NAME> tokens in the given files/dirs with env var <NAME>.
# Exits non-zero if a referenced env var is unset or empty.
set -eu

for target in "$@"; do
    if [ ! -e "$target" ]; then
        echo "substitute-env: $target does not exist, skipping" >&2
        continue
    fi
    # Longest tokens first (sort -r) so PLACEHOLDER_DB never clobbers PLACEHOLDER_DB_USER.
    grep -rhoE 'PLACEHOLDER_[A-Za-z0-9_]+' "$target" | sort -ur | while read -r token; do
        name="${token#PLACEHOLDER_}"
        eval "val=\${$name-}"
        if [ -z "$val" ]; then
            echo "substitute-env: environment variable $name is not set or empty (needed for $token)" >&2
            exit 1
        fi
        # Escape sed replacement special chars: \ & /
        escaped=$(printf '%s' "$val" | sed 's/[&/\\]/\\&/g')
        grep -rlF "$token" "$target" | while read -r f; do
            tmp=$(mktemp)
            sed "s/$token/$escaped/g" "$f" > "$tmp"
            cat "$tmp" > "$f" # rewrite in place: works even when the parent dir is read-only (e.g. /)
            rm -f "$tmp"
        done
    done
done
