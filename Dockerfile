FROM ubuntu:18.04

# Install prerequisites
RUN apt-get update && apt-get install -y \
  ca-certificates \
  wget \
  zip \
  unzip \
  pciutils \
  locales \
  libssl1.0.0 \
  # helper packages
  curl \
  net-tools \
  nano \
  && rm -rf /var/lib/apt/lists/*

# Set the locale
# see: https://stackoverflow.com/questions/28405902/how-to-set-the-locale-inside-a-debian-ubuntu-docker-container
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Add a user
ARG USER=developer
RUN useradd --create-home ${USER}
ENV HOME /home/${USER}

USER ${USER}
WORKDIR ${HOME}

# Container is intentionally started under the root user.
# Starting under non-root user will cause permissions issue when attaching volumes
# See: https://github.com/moby/moby/issues/2259
USER root

# Copy and extract webOS CLI
ARG WEBOS_SDK_PATH=/webOS_TV_SDK
COPY vendor/webos_cli_tv.zip .
RUN unzip webos_cli_tv.zip -d ${WEBOS_SDK_PATH}  && chmod -R +x ${WEBOS_SDK_PATH}/CLI/bin

# Add webos cli to PATH
ENV PATH $PATH:${WEBOS_SDK_PATH}/CLI/bin
