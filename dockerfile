FROM ubuntu:22.04

LABEL maintainer="DevOps Team"
LABEL description="Demo App - Production Ready"
LABEL version="1.0"

# Install only necessary dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/* && \
    # Create non-root user for security
    useradd -m -u 1000 appuser

# Set working directory
WORKDIR /app

# Copy application artifacts from build
COPY --chown=appuser:appuser build/ .

# Switch to non-root user
USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD echo "Container is running" || exit 1

# Application entry point
ENTRYPOINT ["/bin/sh", "-c"]
CMD ["echo '=== Application Started ===' && echo '' && echo 'Build Information:' && cat build.txt && echo '' && echo '=== Running ===' && sleep infinity"]
