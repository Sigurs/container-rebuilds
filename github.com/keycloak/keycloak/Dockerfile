# Stage 1: Build Keycloak with optimizations
FROM quay.io/keycloak/keycloak:${IMAGE_TAG} AS builder
WORKDIR /opt/keycloak
# Add custom providers or themes here
# ...
# Run the build command with server options, e.g., enabling metrics and specifying the database.
RUN /opt/keycloak/bin/kc.sh build --db=postgres --health-enabled=true --metrics-enabled=true

# Stage 2: Create the final optimized image
FROM quay.io/keycloak/keycloak:${IMAGE_TAG} as final
WORKDIR /opt/keycloak
# Copy the augmented runtime from the builder stage
COPY --from=builder /opt/keycloak/lib/quarkus/ /opt/keycloak/lib/quarkus/
# Copy the pre-built Keycloak directory from the builder stage, including custom providers
COPY --from=builder /opt/keycloak/ /opt/keycloak/
# Set the entrypoint to start Keycloak with the --optimized flag
ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start", "--optimized"]