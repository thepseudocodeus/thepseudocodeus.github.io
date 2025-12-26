# Use the latest Debian Bookworm slim image
FROM debian:bookworm-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Set the working directory
WORKDIR /app

# Install essential packages and development tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    git \
    gnupg \
    locales \
    lsb-release \
    python3 \
    python3-pip \
    python3-venv \
    sudo \
    vim \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Set up locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Create a non-root user
ARG USERNAME=developer
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Switch to the non-root user
USER $USERNAME

# Set up Python virtual environment
RUN python3 -m venv /home/$USERNAME/venv
ENV PATH="/home/$USERNAME/venv/bin:$PATH"

# Install some common Python packages
RUN pip install --no-cache-dir \
    pytest \
    flake8 \
    black \
    mypy \
    ipython

# Install Node.js and npm
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - \
    && sudo apt-get install -y nodejs \
    && sudo npm install -g npm@latest

# Install some common Node.js development tools
RUN sudo npm install -g \
    eslint \
    prettier \
    typescript

# Set up Git configuration
RUN git config --global user.email "developer@example.com" \
    && git config --global user.name "Developer"

# Clean up
RUN sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*

# Set the default command to bash
CMD ["/bin/bash"]
