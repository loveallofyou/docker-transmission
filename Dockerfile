FROM alpine
MAINTAINER siqi "masiqi@gmail.com"

# Install transmission and dumb-init
ADD files/repositories /etc/apk/repositories
RUN apk add -U transmission-cli transmission-daemon && \
    wget -O /usr/local/bin/dumb-init \
        https://github.com/Yelp/dumb-init/releases/download/v1.0.0/dumb-init_1.0.0_amd64 && \
    chmod +x /usr/local/bin/dumb-init

# Copy the files to the image
ADD ./files/ /tmp/

# Run the actual build:
#   1. Copy the config file into place
#   2. Copy the run script into place
#   3. Remove all remaining build files and clean our apk cache
RUN mkdir -p /etc/transmission && \
    mkdir -p /opt/transmission/incomplete && \
    mkdir -p /opt/transmission/downloads && \
    sed \
        -e 's|@ROOT_DIR@|/opt/transmission|g' \
        /tmp/settings.json > /etc/transmission/settings.json && \
    mv /tmp/run-transmission.sh /run-transmission.sh && \
    chown -R transmission:transmission /opt/transmission && \
    chown -R transmission:transmission /etc/transmission && \
    rm -rf /tmp/* /var/cache/apk/*

# Set up the volumes
VOLUME ["/opt/transmission/downloads"]
VOLUME ["/opt/transmission/incomplete"]

# Expose our RPC and bind ports
EXPOSE 9091
EXPOSE 51413

CMD ["/usr/local/bin/dumb-init", "/run-transmission.sh"]
