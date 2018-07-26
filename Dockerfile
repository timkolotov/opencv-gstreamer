FROM ubuntu:latest
LABEL maintainer="Tim Kolotov <timophey.kolotov@gmail.com>"

# Install all dependencies and building tools
RUN apt-get -y update && apt-get -y install --no-install-recommends wget cmake python3.6-dev python3-numpy gcc \
    g++ libgstreamer-plugins-base1.0-dev libjpeg-turbo8-dev gstreamer1.0-libav gstreamer1.0-plugins-good gstreamer1.0-plugins-bad \
    && apt-mark manual python3.6 python3-numpy libgstreamer-plugins-base1.0-0 libjpeg-turbo8 \
# Download an unpack opencv
    && wget --no-check-certificate https://github.com/opencv/opencv/archive/3.4.2.tar.gz \
    && tar -v -xzf 3.4.2.tar.gz && cd opencv-3.4.2 && mkdir build && cd build \
# OpenCV building configuration
    && cmake -D CMAKE_BUILD_TYPE=Release \
             -D CMAKE_INSTALL_PREFIX=/usr/local \
             -D PYTHON3_EXECUTABLE=/usr/bin/python3.6 \
             -D PYTHON_INCLUDE_DIR=/usr/include/python3.6/ \
             -D PYTHON_INCLUDE_DIR2=/usr/include/x86_64-linux-gnu/python3.6m/ \
             -D PYTHON_LIBRARY=/usr/lib/python3.6/config-3.6m-x86_64-linux-gnu/libpython3.6.so \
             -D PYTHON3_NUMPY_INCLUDE_DIRS=/usr/lib/python3/dist-packages/numpy/core/include/ \
             -D PYTHON_DEFAULT_EXECUTABLE=/usr/bin/python3 \
             -D BUILD_opencv_python3=ON \
             -D BUILD_opencv_python2=OFF \
             -D BUILD_PYTHON_SUPPORT=ON \
             -D BUILD_EXAMPLES=OFF \
             -D BUILD_DOCS=OFF \
             -D WITH_IPP=OFF \
             -D WITH_FFMPEG=OFF \
             -D WITH_V4L=OFF .. \
# Building and install
    && make -j$(nproc) && make install \
# Cleanup
    && apt-get -y autoremove wget cmake python3.6-dev gcc g++ libgstreamer-plugins-base1.0-dev libjpeg-turbo8-dev \
    && apt-get clean all && rm -rf /var/lib/apt/lists /3.4.2.tar.gz /opencv-3.4.2

# Define default command.
CMD ["python3"]
