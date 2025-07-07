FROM alpine:latest AS build

# Set environment variable for Manager.io version
ARG MANAGER_VERSION
ARG TARGETPLATFORM

RUN apk --no-cache add curl

# Download and extract ManagerServer binary
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ] ; then TARGET=arm64; else TARGET=x64 ; fi; \
    echo "https://github.com/Manager-io/Manager/releases/download/${MANAGER_VERSION}/ManagerServer-linux-${TARGET}.tar.gz"; \
    curl -L "https://github.com/Manager-io/Manager/releases/download/${MANAGER_VERSION}/ManagerServer-linux-${TARGET}.tar.gz" --output /tmp/manager-server.tar.gz; \
    mkdir /tmp/manager-server/; \
    tar -xvzf /tmp/manager-server.tar.gz -C /tmp/manager-server/

FROM mcr.microsoft.com/dotnet/runtime-deps:8.0

# Set environment variable for Manager.io version
ARG MANAGER_VERSION
LABEL build_version="version:- ${MANAGER_VERSION}"

RUN apt update; \
    apt install -y curl; \
    apt clean; \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/manager-server

# Copy the extracted binary
COPY --from=build /tmp/manager-server/ .

# Set permissions for ManagerServer executable
RUN chmod +x /opt/manager-server/ManagerServer

# Define HEALTHCHECK for liveness probe
HEALTHCHECK --interval=10s --timeout=5s --retries=3 \
    CMD curl --fail -s http://localhost:8080/healthz || exit 1

# Run instance of Manager
CMD ["/opt/manager-server/ManagerServer","-port","8080","-path","/data"]

VOLUME /data
EXPOSE 8080