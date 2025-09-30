# container-rebuilds
## Use
Some containers are not build in a way that I want them to and this repo's idea is to fix it.  
Pipelines need optimization.

The usual reason for containers to need rebuilding are:
- They are ran as root for no good reason
- A binary inside the container has been given rights with setcap that aren't actually needed.  

## Containers
### github.com/keycloak/keycloak
Needs optimized build to run with readOnlyFilesystem.  
[Link](https://github.com/keycloak/keycloak/issues/11286#issuecomment-3328420408)

### github.com/chq/CyberChef
Issues:
- Container ran as root
    - Fixed by running in a unprivileged nginx container.
### github.com/paperless-ngx/paperless-ngx
Issues:
- Needs Finnish OCR libraries