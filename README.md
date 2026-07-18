# container-rebuilds
## Use
Some containers are not build in a way that I want them to and this repo's idea is to fix it.  
Pipelines need optimization.

The usual reason for containers to need rebuilding are:
- They are ran as root for no good reason.
- A binary inside the container has been given rights with setcap that aren't actually needed.
- Missing packages.

## Pipeline
Each container has its own workflow that checks upstream's latest release twice a day and builds when a new one appears. All workflows also do a weekly forced rebuild (Mondays) to pick up base-image security patches, and can be triggered manually (always builds). Images are pushed to `ghcr.io/sigurs/container-rebuilds/<name>` tagged with the upstream release version; only the 3 latest versions are kept.

## Containers
### github.com/keycloak/keycloak
Needs optimized build to run with readOnlyFilesystem.  
[Link](https://github.com/keycloak/keycloak/issues/11286#issuecomment-3328420408)

### github.com/gchq/CyberChef
Issues:
- Container ran as root.
    - Fixed by running in a unprivileged nginx container.
### github.com/paperless-ngx/paperless-ngx
Issues:
- Needs Finnish OCR libraries.
### github.com/mlflow/mlflow
Issues:
- Needs Postgres drivers for the database backend store.
    - Fixed by installing `psycopg2-binary`.
### github.com/NOALBS/nginx-obs-automatic-low-bitrate-switching
Issues:
- No official minimal container image.
    - Fixed by packaging the upstream static musl release binary on Alpine, running as non-root. Mount your `config.json` at `/config`.
### github.com/bluenviron/mediamtx
Issues:
- Official image lacks ffmpeg for runOnDemand/runOnReady hooks and logs unavoidable API 404 spam.
    - Fixed by packaging the upstream static build on Alpine with ffmpeg, running as non-root, with known log noise filtered at startup. Mount your config at `/mediamtx.yml`.
### github.com/obsproject/obs-studio
Issues:
- No official container image for running OBS headless.
    - Fixed by installing OBS from the upstream PPA on Ubuntu with Xvfb and x11vnc, running as non-root. View over VNC on port 5900 (set `VNC_PASSWORD` to require a password, `OBS_SCREEN` to change resolution, default 1920x1080x24). Rebuilt nightly since it tracks PPA packages instead of releases.
