FROM ros:humble as base
##################################
ARG ${ROS_DISTRO}=humble

SHELL [ "/bin/bash", "-c" ]

ENV DEBIAN_FRONTEND=noninteractive

RUN             apt-get update \
        &&      apt install curl -y \
        xauth \
        x11-apps \
        &&      curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - \
        &&      apt-get update \
        &&      apt-get upgrade -y \
        &&      apt-get install -y      ros-${ROS_DISTRO}-std-msgs \
                                        ros-${ROS_DISTRO}-rmw-cyclonedds-cpp \
                                        ros-${ROS_DISTRO}-sensor-msgs \
                                        ros-${ROS_DISTRO}-cv-bridge \
                                        ros-${ROS_DISTRO}-usb-cam \
                                        ros-${ROS_DISTRO}-rviz2 \
                                        ros-${ROS_DISTRO}-rviz-common \
                                        ros-${ROS_DISTRO}-rviz-default-plugins \
                                        ros-${ROS_DISTRO}-rviz-visual-tools \
                                        ros-${ROS_DISTRO}-rviz-rendering \
                                        ros-${ROS_DISTRO}-nav2-rviz-plugins \                                        
                                        ros-humble-diagnostic-updater\
                                        python3-pip \
                                        python3-opencv \
                                        graphviz graphviz-dev \
                                        python3-pykdl \
                                        gdb \
                                        --fix-missing --fix-broken --upgrade \
        &&      pip3 install --upgrade --user   pip \
        &&      pip3 install --user     setuptools==58.2.0 \
        &&      rm -rf /var/lib/apt/lists/*




FROM base as develop
####################

SHELL [ "/bin/bash", "-c" ]

ENV DEBIAN_FRONTEND=noninteractive


RUN             curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - \
        &&      apt-get update 

RUN  apt update && sudo apt install curl
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

RUN apt install ros-${ROS_DISTRO}-desktop -y


FROM base as release
####################
ENV DISPLAY=:0


ADD /src/ /root/ros2_ws/src


WORKDIR /root/ros2_ws

RUN     source /opt/ros/${ROS_DISTRO}/setup.bash && \
        colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release
        
ENTRYPOINT ["/bin/bash", "-c", "source /opt/ros/${ROS_DISTRO}/setup.bash"]











