# Use a lightweight base image
FROM debian:bookworm-slim

# Install required dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    dos2unix \
    dnsmasq \
    dnsutils \
    iproute2 \
    iputils-ping \
    socat \
    && rm -rf /var/lib/apt/lists/*

# Set up directories
RUN mkdir -p /opt/mycoria /etc/mycoria /var/lib/mycoria

# Download the latest Mycoria binary
RUN wget https://github.com/mycoria/mycoria/releases/latest/download/mycoria_linux_amd64 -O /opt/mycoria/mycoria \
    && chmod +x /opt/mycoria/mycoria

# Create a symlink in PATH
RUN ln -s /opt/mycoria/mycoria /usr/local/bin/mycoria

# Create data directory for state
RUN mkdir -p /var/lib/mycoria

# Create TUN device directory (may help with detection)
RUN mkdir -p /dev/net && \
    mknod /dev/net/tun c 10 200 || true

# Configure dnsmasq for .myco domains
RUN echo "server=/myco/fd00::b909" > /etc/dnsmasq.conf

# Copy entrypoint script
COPY entrypoint.sh /opt/mycoria/
RUN chmod +x /opt/mycoria/entrypoint.sh
RUN dos2unix /opt/mycoria/entrypoint.sh

EXPOSE 12345/tcp
EXPOSE 47370/tcp
EXPOSE 47369/tcp

WORKDIR /opt/mycoria

ENTRYPOINT ["/opt/mycoria/entrypoint.sh"]

CMD ["run", "--config", "/etc/mycoria/config.yaml"]
