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
      emacs-nox

ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"

# Install wget to fetch Miniconda
RUN apt-get update && \
    apt-get install -y wget;

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

COPY sources.list /etc/apt/sources.list

RUN apt update && apt install -y kicad/bookworm-backports kicad-libraries/bookworm-backports ngspice/bookworm-backports

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

RUN conda init bash

RUN conda create -y -n phenv python=3.12 numpy scipy matplotlib pandas sympy ipykernel

RUN wget https://sourceforge.net/projects/xschem/files/latest/download -O xschem-latest.tar.gz; \
   tar -xzvf xschem-latest.tar.gz; \
   cd xschem-3.4.6; \
   apt install -y bison debhelper flex libcairo2-dev libx11-xcb-dev libxpm-dev libxrender-dev mawk tcl-dev tk-dev; \
   ./configure; \
   make; \
   make install

RUN rm -r xschem-latest.tar.gz xschem-3.4.6

RUN apt install -y vim-gtk3

# RUN arch=$(uname -m) && \
#     if [ "$arch" = "x86_64" ]; then \
#     QUARTO_URL="https://github.com/quarto-dev/quarto-cli/releases/download/v1.6.40/quarto-1.6.40-linux-amd64.deb"; \
#     elif [ "$arch" = "aarch64" ]; then \
#     QUARTO_URL="https://github.com/quarto-dev/quarto-cli/releases/download/v1.6.40/quarto-1.6.40-linux-arm64.deb "; \
#     else \
#     echo "Unsupported architecture: $arch"; \
#     exit 1; \
#     fi && \
#     wget $QUARTO_URL -O quarto.deb && \
#     dpkg -i quarto.deb && \
#     rm -f quarto.deb

RUN conda run -n phenv pip install --root-user-action=ignore quarto quarto-cli
    
COPY . /app

RUN echo "source activate phenv\nexport QUARTO_PYTHON=/root/miniconda3/envs/phenv/bin/python" >> ~/.bashrc

run sed -z "s,import sys,import sys\nimport os\nos.environ['QUARTO_PYTHON'] = '/root/miniconda3/envs/phenv/bin/python'," -i /root/miniconda3/envs/phenv/bin/quarto 

# CMD ["/app/entrypoint.sh"]
EXPOSE 8080
