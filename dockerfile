# Multi-stage build for demo-app
FROM ubuntu:22.04 AS builder

LABEL maintainer="DevOps Team"
LABEL description="Demo App - Built from GitHub Actions Workflow"

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    git \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Stage 2: Runtime
FROM ubuntu:22.04

LABEL maintainer="DevOps Team"
LABEL description="Demo App Runtime"
LABEL version="1.0"

# Install runtime dependencies only
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/* && \
    # Create non-root user for security
    useradd -m -u 1000 appuser

WORKDIR /app

# Copy build artifacts from workflow
COPY --chown=appuser:appuser build/ /app/

# Set user to non-root
USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1 || echo "Running"

# Default command
ENTRYPOINT ["/bin/sh", "-c"]
CMD ["echo 'Demo App Container Started' && cat /app/build.txt && sleep infinity"]
