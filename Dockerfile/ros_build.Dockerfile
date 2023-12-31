FROM ros:noetic

LABEL maintainer="numajinfei@163.com"

# Install dependencies
# RUN sed -i "s/security.ubuntu.com/mirrors.ustc.edu.cn/g" /etc/apt/sources.list \
#  && sed -i "s/archive.ubuntu.com/mirrors.ustc.edu.cn/g" /etc/apt/sources.list \ 
#  && apt-get update && apt-get install -y --no-install-recommends \
RUN apt-get update && apt-get install -y --no-install-recommends \
  wget \
  git \
  htop \
  vim \
  unzip \
  net-tools \
  iputils-ping \
  libgpiod-dev \
  libyaml-cpp-dev \
# nav and pcl:
  ros-${ROS_DISTRO}-pcl-conversions \
  ros-${ROS_DISTRO}-bondcpp \
  # ros-${ROS_DISTRO}-test-msgs \
  ros-${ROS_DISTRO}-behaviortree-cpp-v3 \
  # ros-${ROS_DISTRO}-rviz-common \
  # ros-${ROS_DISTRO}-rviz-default-plugins \
  ros-${ROS_DISTRO}-angles \
  ros-${ROS_DISTRO}-cv-bridge \
  ros-${ROS_DISTRO}-ompl \
  ros-${ROS_DISTRO}-image-transport \
  ros-${ROS_DISTRO}-gazebo-ros-pkgs \
  ros-${ROS_DISTRO}-libg2o \
  ros-${ROS_DISTRO}-laser-geometry \
  ros-${ROS_DISTRO}-pcl-ros \
  ros-${ROS_DISTRO}-costmap-converter \
  ros-${ROS_DISTRO}-tf2-geometry-msgs \
  ros-${ROS_DISTRO}-move-base \
  graphicsmagick* \
  libsuitesparse-dev \
  libsdl-image1.2-dev \
  libsdl-dev \
# opencv  
  libopencv-dev \
# vision rependence packages:
  ros-${ROS_DISTRO}-cv-bridge \
  python3-pip \
  && rm -rf /var/lib/apt/lists/* \
# AI rependence packages:
  && pip3 install opencv-python \
  && pip3 install torch torchvision torchaudio \
  && pip3 install ultralytics torchsummary \
  # && pip3 install opencv-python -i https://pypi.tuna.tsinghua.edu.cn/simple \
  # && pip3 install torch torchvision torchaudio -i https://pypi.tuna.tsinghua.edu.cn/simple \
  && pip3 install Pillow requests minio fastapi uvicorn pydantic
 


# Install nlohmann json
RUN wget https://github.com/nlohmann/json/releases/download/v3.9.1/json.hpp \
# RUN wget https://github.com/numajinfei/vision/releases/download/v0.0.1-3rdparty/json.hpp \
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
  && echo "/opt/mqtt/lib" >> /etc/ld.so.conf.d/mqtt.conf \
  && mkdir -p /opt/mqtt/lib \
  && cp /usr/local/lib/libpaho* /opt/mqtt/lib \
  && rm -r paho.mqtt.cpp-1.2.0 build

# Build libredwg
RUN wget -O libredwg.tar.gz https://ftp.gnu.org/gnu/libredwg/libredwg-0.12.4.tar.gz \
  && tar -xzf libredwg.tar.gz \
  && rm libredwg.tar.gz \
  && cd libredwg-0.12.4 \
  #&& ./configure --prefix=/opt/redwg --disable-bindings --enable-release \
  && ./configure --disable-bindings --enable-release \
  && make -j `nproc` \  
  && make install \
  # 直接生成在 /usr/local下，改用/opt/redwg下会出现编译通不过问题
  && echo "/opt/redwg/lib" >> /etc/ld.so.conf.d/redwg.conf \
  && mkdir -p /opt/redwg/lib \
  && cp /usr/local/lib/libredwg* /opt/redwg/lib \
  && cd - \
  && rm -r libredwg-0.12.4 \
  && ldconfig



# copy opencv lib
# COPY --from=chs_ros2_ros_opencv:latest /opt/opencv /opt/opencv
# COPY --from=chs_ros2_ros_opencv:latest /etc/ld.so.conf.d/OpenCV.conf /etc/ld.so.conf.d/OpenCV.conf


# Copy pcl ld config file
#COPY --from=pcl /etc/ld.so.conf.d/Pcl.conf /etc/ld.so.conf.d/Pcl.conf

# Copy mqtt 
#COPY /usr/local/lib/libpaho* /opt/mqtt/lib/

