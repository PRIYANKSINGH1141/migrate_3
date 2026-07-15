FROM ubuntu:22.04

LABEL maintainer="DevOps Team"
LABEL description="Demo App - Production Ready"
LABEL version="1.0"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -m -u 1000 appuser

WORKDIR /app

COPY --chown=appuser:appuser build/ ./

USER appuser

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD test -f build.txt || exit 1

ENTRYPOINT ["/bin/sh", "-c"]

CMD ["echo '=== Application Started ==='; \
echo ''; \
echo 'Build Information:'; \
cat build.txt; \
echo ''; \
echo 'Docker Image Built Successfully';"]
