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
      emacs-nox

RUN wget https://sourceforge.net/projects/xschem/files/latest/download -O xschem-latest.tar.gz; \
    tar -xzvf xschem-latest.tar.gz; \
    cd xschem-3.4.6; \
    apt install -y bison debhelper flex libcairo2-dev libx11-xcb-dev libxpm-dev libxrender-dev mawk tcl-dev tk-dev; \
    ./configure; \
    make; \
    make install

RUN rm -r xschem-latest.tar.gz xschem-3.4.6

#
# trouble building ngspice on amd64
#
# RUN apt-get update && apt-get -y install bc bison flex libxaw7 libxaw7-dev libx11-6 libx11-dev libreadline8 libxmu6
# RUN apt-get update && apt-get -y install build-essential libtool gperf libxml2 libxml2-dev libxml-libxml-perl libgd-perl
# RUN apt-get update && apt-get -y install g++ gfortran make cmake libfl-dev libfftw3-dev libreadline-dev
# 
# RUN wget https://sourceforge.net/projects/ngspice/files/ng-spice-rework/43/ngspice-43.tar.gz/download -O ngspice-43.tar.gz; \
#     tar -xzvf ngspice-43.tar.gz;
# 
# RUN cd ngspice-43; \
#     if [ "$TARGETPLATFORM" == "linux/amd64" ]; then \
#         ./configure --disable-dependency-tracking; \
#     else \
#        ./configure; \
#     fi; \
#     make; \
#     make install
#
# RUN rm -rf ngspice-43.tar.gz ngspice-43
#

ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"

# Install wget to fetch Miniconda
RUN apt-get update && \
    apt-get install -y wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Miniconda on x86 or ARM platforms
RUN arch=$(uname -m) && \
    if [ "$arch" = "x86_64" ]; then \
    MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"; \
    elif [ "$arch" = "aarch64" ]; then \
    MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh"; \
    else \
    echo "Unsupported architecture: $arch"; \
    exit 1; \
    fi && \
    wget $MINICONDA_URL -O miniconda.sh && \
    mkdir -p /root/.conda && \
    bash miniconda.sh -b -p /root/miniconda3 && \
    rm -f miniconda.sh

RUN conda install -y -n base ipykernel --update-deps --force-reinstall

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
