# container-rebuilds
## Use
Some containers are not build in a way that I want them to and this repo's idea is to fix it. <br>

The usual reason for containers to need rebuilding are:
- They are ran as root for no good reason
- A binary inside the container has been given rights with setcap that aren't actually needed.

## Containers
### github.com/chq/CyberChef
Issues:
- Container ran as root
    - Fixed by running in a unprivileged nginx container.

### https://github.com/open-webui/open-webui
Issues:
- Container ran as root
    - Fixed by building as non-root.