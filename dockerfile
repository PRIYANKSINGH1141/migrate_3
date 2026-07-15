FROM alpine:latest

# Set working directory
WORKDIR /app

# Copy build artifacts
COPY build/ /app/

# Default command
CMD ["sh", "-c", "echo 'Application container running' && cat /app/build.txt"]
