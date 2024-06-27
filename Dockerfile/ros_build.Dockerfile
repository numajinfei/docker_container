FROM ros:noetic
##############################################
## ros:noetic + cartographer environment
## v1.0.1
##############################################
LABEL maintainer="numajinfei@163.com"

# Install dependencies
# RUN sed -i "s/security.ubuntu.com/mirrors.ustc.edu.cn/g" /etc/apt/sources.list \
#  && sed -i "s/archive.ubuntu.com/mirrors.ustc.edu.cn/g" /etc/apt/sources.list \ 
#  && apt-get update && apt-get install -y --no-install-recommends \
RUN apt-get update && apt-get install -y --no-install-recommends \
  wget \
  minicom \
  autoconf automake libtool curl make g++ unzip \
  pv \
  git \
  htop \
  vim \
  unzip \
  net-tools \
  iputils-ping \
  libgpiod-dev \
  libyaml-cpp-dev \
  libc++-dev libceres-dev \
# nav and pcl:
  ros-${ROS_DISTRO}-pcl-conversions \
  ros-${ROS_DISTRO}-bondcpp \
  ros-${ROS_DISTRO}-angles \
  ros-${ROS_DISTRO}-ompl \
  ros-${ROS_DISTRO}-image-transport \
  ros-${ROS_DISTRO}-libg2o \
  ros-${ROS_DISTRO}-laser-geometry \
  ros-${ROS_DISTRO}-pcl-ros \
  ros-${ROS_DISTRO}-costmap-converter \
  ros-${ROS_DISTRO}-tf2-geometry-msgs \
  ros-${ROS_DISTRO}-eigen-conversions \
  ros-${ROS_DISTRO}-urdf \
#   ros-${ROS_DISTRO}-move-base \
  ros-${ROS_DISTRO}-map-msgs \
  ros-${ROS_DISTRO}-robot-state-publisher \
  ros-${ROS_DISTRO}-rviz \
  liborocos-bfl-dev \
  graphicsmagick* \
  libsuitesparse-dev \
  libsdl-image1.2-dev \
  libsdl-dev \
# cartographer dependence lib:
  libgoogle-glog-dev libgflags-dev libatlas-base-dev libeigen3-dev \
  libprotobuf-dev protobuf-compiler libprotoc-dev python3-sphinx sphinx-common sphinx-doc \
  liblua5.2-dev libcairo2-dev \
  libgmock-dev libpcl-dev \
  python3-sphinx \
  python3-wstool \
  python3-rosdep \
  ninja-build \
  stow \
# opencv  
  libopencv-dev \
# vision dependence packages:
  ros-${ROS_DISTRO}-cv-bridge \
  python3-pip \
  && rm -rf /var/lib/apt/lists/* \
# AI/py dependence packages:
  && pip3 install opencv-python \
#   && pip3 install opencv-python -i https://pypi.tuna.tsinghua.edu.cn/simple \
  && pip3 install Sphinx

# Install protobuf
RUN git clone -b v3.6.0 https://github.com/protocolbuffers/protobuf.git \
  && cd protobuf \
  && git submodule update --init --recursive \
  && ./autogen.sh \
  && ./configure \
  && make \
  && make install \
  && ldconfig \
  && rm protobuf -rf \
  && protoc --version \
  && mkdir /carto

# Install ceres-slover
# RUN wget http://ceres-solver.org/ceres-solver-2.1.0.tar.gz \
#   && tar -zxvf ceres-solver-2.1.0.tar.gz \
#   && cd ceres-solver-2.1.0 \
#   && mkdir build \
#   && cd build \
#   && cmake ..  \
#   && make install \
#   && rm ceres-solver-2.1.0.tar.gz -rf && ldconfig

# # Install cartographer and cartographer_ros
# RUN /bin/bash -c 'rm /etc/ros/rosdep/sources.list.d/20-default.list' \
#   && mkdir /carto_ws/src -p  && cd /carto_ws \
#   && rosdep init && rosdep update \
#   && rosdep install --from-paths src --ignore-src --rosdistro=${ROS_DISTRO} -y \
#   && wget https://github.com/cartographer-project/cartographer/archive/refs/tags/2.0.0.tar.gz \
#   && wget https://github.com/cartographer-project/cartographer_ros/archive/refs/tags/1.0.0.tar.gz \
#   && tar -zxvf 2.0.0.tar.gz \
#   && tar -zxvf 1.0.0.tar.gz \
#   && mv cartographer_ros-1.0.0 cartographer_ros \
#   && mv cartographer-2.0.0 cartographer \
#   && pwd && ls && mv cartographer* ./src \
#   && cd /carto_ws/src/cartographer/scripts \
#   && ./install_abseil.sh \
#   && cd .. && mkdir build && cd build \
#   && cmake .. && make \
#   && make test && make install && ldconfig

# WORKDIR /carto_ws
# RUN /bin/bash -c 'source /opt/ros/${ROS_DISTRO}/setup.bash && catkin_make_isolated --install'



# Install cartographer and cartographer_ros
# RUN /bin/bash -c 'rm /etc/ros/rosdep/sources.list.d/20-default.list' \
#   && mkdir /carto_ws/src -p  && cd /carto_ws \
#   && rosdep init && rosdep update \
#   && rosdep install --from-paths src --ignore-src --rosdistro=${ROS_DISTRO} -y \
#   && wget https://github.com/cartographer-project/cartographer/archive/refs/tags/2.0.0.tar.gz \
#   && wget https://github.com/cartographer-project/cartographer_ros/archive/refs/tags/1.0.0.tar.gz \
#   && tar -zxvf 2.0.0.tar.gz \
#   && tar -zxvf 1.0.0.tar.gz \
#   && mv cartographer_ros-1.0.0 cartographer_ros \
#   && mv cartographer-2.0.0 cartographer \
#   && pwd && ls && mv cartographer* ./src \
#   && cd /carto_ws/src/cartographer/scripts \
#   && ./install_abseil.sh \
#   && cd .. && mkdir build && cd build \
#   && cmake .. && make \
#   && make test && make install && ldconfig

WORKDIR /carto_ws
RUN wget http://ceres-solver.org/ceres-solver-2.1.0.tar.gz \
  && tar -zxvf ceres-solver-2.1.0.tar.gz \
  && cd ceres-solver-2.1.0 \
  && mkdir build \
  && cd build \
  && cmake .. -G Ninja \
  && ninja && CTEST_OUTPUT_ON_FAILURE=1 ninja test \
  && ninja install

# RUN wget https://github.com/cartographer-project/cartographer/archive/refs/tags/2.0.0.tar.gz \
#   && wget https://github.com/cartographer-project/cartographer_ros/archive/refs/tags/1.0.0.tar.gz \
#   && tar -zxvf 2.0.0.tar.gz \
#   && tar -zxvf 1.0.0.tar.gz \
#   && mv cartographer_ros-1.0.0 cartographer_ros \
#   && mv cartographer-2.0.0 cartographer \
#   && pwd && echo "####### current floder1:" && ls \
#   && /bin/bash -c 'rm /etc/ros/rosdep/sources.list.d/20-default.list' \
#   && wstool init src \
#   && mv cartographer* ./src \
#   && wstool update -t src \
#   && pwd && echo "####### current floder2:" && ls \
#   && echo "####### current src floder:" && ls ./src \
#   && rosdep init && rosdep fix-permissions && rosdep update \
# #   && apt-mark hold libceres-dev \
#   && rosdep install --from-paths ./src --ignore-src --rosdistro=${ROS_DISTRO} -y \
#   && ./src/cartographer/scripts/install_abseil.sh

RUN /bin/bash -c 'rm /etc/ros/rosdep/sources.list.d/20-default.list' \
  && mkdir /carto_ws/src -p  && cd /carto_ws \
  && rosdep init && rosdep update \
  && rosdep install --from-paths src --ignore-src --rosdistro=${ROS_DISTRO} -y \
  && wget https://github.com/cartographer-project/cartographer/archive/refs/tags/2.0.0.tar.gz \
  && wget https://github.com/cartographer-project/cartographer_ros/archive/refs/tags/1.0.0.tar.gz \
  && tar -zxvf 2.0.0.tar.gz \
  && tar -zxvf 1.0.0.tar.gz \
  && mv cartographer_ros-1.0.0 cartographer_ros \
  && mv cartographer-2.0.0 cartographer \
  && pwd && ls && mv cartographer* ./src \
  && cd /carto_ws/src/cartographer/scripts \
  && ./install_abseil.sh \
  && cd .. && mkdir build && cd build \
  && cmake .. && make \
  && make test && make install && ldconfig

RUN /bin/bash -c 'source /opt/ros/${ROS_DISTRO}/setup.bash && catkin_make_isolated --install --use-ninja'

# Install nlohmann json
RUN wget https://github.com/nlohmann/json/releases/download/v3.11.3/json.hpp \
  && mkdir -p /usr/local/include/nlohmann \
  && mv json.hpp /usr/local/include/nlohmann/json.hpp

# Build paho mqtt c
RUN wget -O paho.mqtt.c.tar.gz https://github.com/eclipse/paho.mqtt.c/archive/refs/tags/v1.3.9.tar.gz \
  && tar -xzf paho.mqtt.c.tar.gz \
  && rm paho.mqtt.c.tar.gz \
  && cmake \
    -D CMAKE_BUILD_TYPE=Release \    
    -D PAHO_ENABLE_TESTING=OFF \
    -D PAHO_WITH_SSL=OFF \
    -D PAHO_HIGH_PERFORMANCE=ON \
    -S paho.mqtt.c-1.3.9/ \
    -Bbuild/ \
  && cmake --build build/ --target install \
  && rm -r paho.mqtt.c-1.3.9 build

# Build paho mqtt cpp
RUN wget -O paho.mqtt.cpp.tar.gz https://github.com/eclipse/paho.mqtt.cpp/archive/refs/tags/v1.2.0.tar.gz \
  && tar -xzf paho.mqtt.cpp.tar.gz \
  && rm paho.mqtt.cpp.tar.gz \
  && cmake \
    -D CMAKE_BUILD_TYPE=Release \
    #-D PAHO_BUILD_STATIC=TRUE \
    -D PAHO_WITH_SSL=OFF \
    -S paho.mqtt.cpp-1.2.0/ \
    -Bbuild/ \
  && cmake --build build/ --target install \
#   && echo "/opt/mqtt/lib" >> /etc/ld.so.conf.d/mqtt.conf \
#   && mkdir -p /opt/mqtt/lib \
#   && cp /usr/local/lib/libpaho* /opt/mqtt/lib \
  && rm -r paho.mqtt.cpp-1.2.0 build




# copy opencv lib
# COPY --from=chs_ros2_ros_opencv:latest /opt/opencv /opt/opencv
# COPY --from=chs_ros2_ros_opencv:latest /etc/ld.so.conf.d/OpenCV.conf /etc/ld.so.conf.d/OpenCV.conf


# Copy pcl ld config file
#COPY --from=pcl /etc/ld.so.conf.d/Pcl.conf /etc/ld.so.conf.d/Pcl.conf

# Copy mqtt 
#COPY /usr/local/lib/libpaho* /opt/mqtt/lib/

