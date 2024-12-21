FROM mcr.microsoft.com/devcontainers/base:bookworm

#
# docker buildx build --push --platform linux/arm64,linux/amd64 --tag us.gcr.io/gcpdrive-sjstest/novnc:1 .
#
#ARG USERNAME=user
#ARG USER_UID=1000
#ARG USER_GID=$USER_UID
#
# Create the user
# RUN groupadd --gid $USER_GID $USERNAME \
#     && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
#     #
#     # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
#     && apt-get update \
#     && apt-get install -y sudo \
#     && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
#     && chmod 0440 /etc/sudoers.d/$USERNAME
#
# ********************************************************
# * Anything else you want to do like clean up goes here *
# ********************************************************

# Install git, supervisor, VNC, & X11 packages
RUN set -ex; \
    apt-get update; \
    apt-get install -y \
      bash \
      fluxbox \
      git \
      net-tools \
      novnc \
      supervisor \
      x11vnc \
      xterm \
      xvfb \
      ngspice \
      xschem

# Setup demo environment variables
ENV HOME=/home/vscode \
    DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=C.UTF-8 \
    DISPLAY=:0.0 \
    DISPLAY_WIDTH=1920 \
    DISPLAY_HEIGHT=1080 \
    TZ=America/Indiana \
    RUN_XTERM=yes \
    RUN_FLUXBOX=yes

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY . /app
#CMD ["/app/entrypoint.sh"]
EXPOSE 8080
