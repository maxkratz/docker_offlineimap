# Use ubuntu 18.04
FROM ubuntu:18.04
LABEL maintainer="Max Kratz <account@maxkratz.com>"
ENV DEBIAN_FRONTEND=noninteractive

# Update and install various packages
RUN apt-get update -q && \
    apt-get upgrade -yq && \
    apt-get install -yq sudo lsb-release locales bash-completion tzdata ca-certificates

# Create a user and give it sudo permissions
RUN useradd -m -d /home/ubuntu ubuntu -p $(perl -e 'print crypt("ubuntu", "salt"),"\n"') && \
    echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Use en utf8 locales
RUN locale-gen en_US.UTF-8

# Switch to 'ubuntu' user
USER ubuntu
WORKDIR /home/ubuntu
ENV HOME=/home/ubuntu
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# Install specific packages
RUN sudo apt install -y offlineimap

# Remove apt lists (for storage efficiency)
RUN sudo rm -rf /var/lib/apt/lists/*

# Update certificates
RUN sudo update-ca-certificates

# Assumed mount points
# /mnt/mail = output folder
# /mnt/config = config
# /mnt/secret = secrets
# /mnt/log = logs

# Check if logging is enabled
CMD if [ "${MAILLOG}" = "TRUE" ]; \
    then mkdir -p /mnt/log && offlineimap -c /mnt/config/offlineimap.conf -l /mnt/log/$(date +'%Y-%m-%d_%H-%M-%S')_mail-backup.log; \
    else offlineimap -c /mnt/config/offlineimap.conf; \
    fi
