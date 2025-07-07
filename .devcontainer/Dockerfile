# ------------------------------------------------------------------------------
# 1. Base Image & Build Arguments
# ------------------------------------------------------------------------------
ARG ROS_DISTRO=jazzy
FROM ghcr.io/sloretz/ros:${ROS_DISTRO}-simulation


# ------------------------------------------------------------------------------
# 2. User & Permissions Setup
# ------------------------------------------------------------------------------
ARG USERNAME=rdev
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG INSTALL_EXTRA=false

# Delete non-root user if it exists in container
RUN if id -u $USER_UID ; then userdel `id -un $USER_UID` ; fi

# Create the non-root user and add sudo support
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME --shell /bin/bash \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------------------------
# 3. Environment Variables
# ------------------------------------------------------------------------------
ENV ROS_DISTRO=$ROS_DISTRO
ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_WORKSPACE=/home/${USERNAME}/ros_ws
ENV COLCON_HOME=/home/${USERNAME}/.colcon
ENV INSTALL_EXTRA=${INSTALL_EXTRA}

# Set the shell to support the "source" command
SHELL ["/bin/bash", "-euo", "pipefail", "-c"]

# ------------------------------------------------------------------------------
# 4. System & Python Setup
# ------------------------------------------------------------------------------
RUN apt-get update && apt-get upgrade -yq \
    && apt-get install -y python3-pip \
    && rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------------------------
# 5. Optional: Install ROS 2 Simulation Utilities
# ------------------------------------------------------------------------------
# apt-get install -y ros-${ROS_DISTRO}-ros-gz --no-install-recommends
# hadolint ignore=DL3008
RUN if [ "${INSTALL_EXTRA}" = "true" ]; then \
        apt-get update \
        && apt-get install -y ros-${ROS_DISTRO}-ros-gz \
        && rm -rf /var/lib/apt/lists/*; \
    else \
        echo "skip sim"; \
    fi

# ------------------------------------------------------------------------------
# 6. Python Dependencies
# ------------------------------------------------------------------------------
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt || true

# ------------------------------------------------------------------------------
# 7. Workspace & Entrypoint Setup
# ------------------------------------------------------------------------------
WORKDIR ${ROS_WORKSPACE}/
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# ------------------------------------------------------------------------------
# 8. Final User, Shell, and Entrypoint
# ------------------------------------------------------------------------------
USER $USERNAME
# Rosdep update
RUN rosdep update

# # Add user to video group to allow access to webcam
# RUN sudo usermod --append --groups video $USERNAME

# # Source the ROS setup file
# RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc

# SHELL ["/bin/bash"]
# ENTRYPOINT ["/entrypoint.sh"]






