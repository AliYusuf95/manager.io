FROM alpine:latest AS build

# Set environment variable for Manager.io version
ARG MANAGER_VERSION

# Download and extract ManagerServer binary
ADD https://github.com/Manager-io/Manager/releases/download/${MANAGER_VERSION}/ManagerServer-linux-x64.tar.gz /tmp/manager-server.tar.gz

RUN mkdir /tmp/manager-server/; \
    tar -xzf /tmp/manager-server.tar.gz -C /tmp/manager-server/

FROM mcr.microsoft.com/dotnet/runtime-deps:8.0

# Set environment variable for Manager.io version
ARG MANAGER_VERSION
LABEL build_version="version:- ${MANAGER_VERSION}"

RUN apt-get update \
    && apt-get install -y curl

WORKDIR /opt/manager-server

# Copy the extracted binary
COPY --from=build /tmp/manager-server/* .

# Set permissions for ManagerServer executable
RUN chmod +x /opt/manager-server/ManagerServer

# Define HEALTHCHECK for liveness probe
HEALTHCHECK --interval=10s --timeout=5s --retries=3 \
    CMD curl --fail -s http://localhost:8080/healthz || exit 1

# Run instance of Manager
CMD ["/opt/manager-server/ManagerServer","-port","8080","-path","/data"]

VOLUME /data
EXPOSE 8080