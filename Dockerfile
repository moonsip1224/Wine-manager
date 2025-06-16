# Wine Manager - Railway Deployment
# This Dockerfile is used by Railway.com for cloud deployment

FROM ubuntu:focal

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Install base system dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get -y install python3 python-is-python3 xvfb x11vnc xdotool wget tar supervisor net-tools gnupg2 curl software-properties-common x11-utils && \
    apt-get -y install xfce4 xfce4-goodies firefox fonts-liberation fonts-dejavu-core fonts-freefont-ttf onboard && \
    echo '$$Hello1$$' > /root/x11vnc_password.txt && \
    apt-get -y full-upgrade && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy configuration files from railway folder
COPY railway/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY railway/supervisord-wine.conf /etc/supervisor/conf.d/supervisord-wine.conf
COPY railway/supervisord-onboard.conf /etc/supervisor/conf.d/supervisord-onboard.conf

# Copy all railway scripts
COPY railway/start.sh /root/start.sh
COPY railway/healthcheck.sh /root/healthcheck.sh
COPY railway/install-dependencies.sh /root/install-dependencies.sh
COPY railway/setup-environment.sh /root/setup-environment.sh
COPY railway/install-novnc.sh /root/install-novnc.sh
COPY railway/install-wine.sh /root/install-wine.sh
COPY railway/install-vinegar.sh /root/install-vinegar.sh
COPY railway/setup-desktop.sh /root/setup-desktop.sh
COPY railway/configure-services.sh /root/configure-services.sh

# Make all scripts executable
RUN chmod +x /root/*.sh

# Set Wine environment variables (Vinegar will create the prefix)
ENV WINEPREFIX /root/prefix64
ENV WINEARCH win64
ENV DISPLAY :0

WORKDIR /root/

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD ["/root/healthcheck.sh"]

CMD ["/root/start.sh"]
