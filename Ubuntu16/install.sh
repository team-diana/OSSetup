#!/bin/bash

prompt_yn_question()
{
    while true; do
        read -p "$1" yn
        case $yn in
            [Yy]* ) return 1;;
            [Nn]* ) return 0;;
            * ) echo "Please answer [y/n]";;
        esac
    done
}

echo "Updating system"
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt update && sudo apt upgrade -y

# DEFAULT OR DEPENDENCIES
sudo apt install openssh-server wget curl vim tree net-tools cmake git cmake-curses-gui pkg-config -y

# prompt_yn_question "Do you want to set DIANA Wallpaper? [y/n]"
# ret=$?
# if [ "$ret" -eq 1 ]; then
#
#     mkdir -p ~/Pictures/Wallpapers && cp -f diana-mars-wallpaper.png ~/Pictures/Wallpapers && gsettings set org.gnome.desktop.background picture-uri file:///$HOME/Pictures/Wallpapers/diana-mars-wallpaper.png
#
# fi

prompt_yn_question "Do you want to install Atom? [y/n]"
ret=$?
if [ "$ret" -eq 1 ]; then
    curl -sL https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -
    sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
    sudo apt update
    sudo apt install atom -y
    apm install -c atom-ide-ui atom-clock autosave-onchange language-cmake language-doxygen markdown-writer language-make
fi


prompt_yn_question "Do you want to install CUDA 9.0? [y/n]"
ret=$?
if [ "$ret" -eq 1 ]; then

    prompt_yn_question "Do you want to DOWNLOAD CUDA 9.0? [y/n]"
    ret=$?
    if [ "$ret" -eq 1 ]; then

        mkdir -p Cuda9.0
        cd Cuda9.0 && wget https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda_9.0.176_384.81_linux-run \
        https://developer.nvidia.com/compute/cuda/9.0/Prod/patches/1/cuda_9.0.176.1_linux-run \
        https://developer.nvidia.com/compute/cuda/9.0/Prod/patches/2/cuda_9.0.176.2_linux-run \
        https://developer.nvidia.com/compute/cuda/9.0/Prod/patches/3/cuda_9.0.176.3_linux-run \
        https://developer.nvidia.com/compute/cuda/9.0/Prod/patches/4/cuda_9.0.176.4_linux-run

        mv cuda_9.0.176_384.81_linux-run cuda_9.0.176_384.81_linux.run
        mv cuda_9.0.176.1_linux-run      cuda_9.0.176.1_linux.run
        mv cuda_9.0.176.2_linux-run      cuda_9.0.176.2_linux.run
        mv cuda_9.0.176.3_linux-run      cuda_9.0.176.3_linux.run
        mv cuda_9.0.176.4_linux-run      cuda_9.0.176.4_linux.run
        cd ..
    fi

    chmod +x Cuda9.0/cuda*

    sudo sh Cuda9.0/cuda_9.0.176_384.81_linux.run
    sudo sh Cuda9.0/cuda_9.0.176.1_linux.run
    sudo sh Cuda9.0/cuda_9.0.176.2_linux.run
    sudo sh Cuda9.0/cuda_9.0.176.3_linux.run
    sudo sh Cuda9.0/cuda_9.0.176.4_linux.run
    echo 'export PATH=/usr/local/cuda/bin:$PATH' >> ~/.bashrc
    echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
fi

prompt_yn_question "Do you want to install NVCC? [y/n]"
ret=$?
if [ "$ret" -eq 1 ]; then
    sudo apt install nvidia-cuda-toolkit -y
fi

prompt_yn_question "Do you want to install ZED SDK 2.7.1 for CUDA 9.0 and Ubuntu 16? [y/n]"
ret=$?
if [ "$ret" -eq 1 ]; then

    mkdir -p ZED_SDK
    cd ZED_SDK && wget -nc https://download.stereolabs.com/zedsdk/2.7/ubuntu16_cuda9
    cd ..

    chmod +x ZED_SDK/ubuntu16_cuda9
    sh ZED_SDK/ubuntu16_cuda9
fi

# OPENCV
sudo apt-get install libopencv-dev
prompt_yn_question "Do you want to install OpenCV? [y/n]"
ret=$?
if [ "$ret" -eq 1 ]; then
    mkdir -p OpenCV
    cd OpenCV

    wget https://github.com/opencv/opencv/archive/4.0.1.zip -O opencv-4.0.1.zip
    unzip opencv-4.0.1.zip

    git clone https://github.com/opencv/opencv_extra.git
    git clone https://github.com/opencv/opencv_contrib


    mkdir -p build_opencv
    cd build_opencv

    prompt_yn_question "OpenCV: Do you want to generate Makefile for OpenCV? [y/n]"
    ret=$?
    if [ "$ret" -eq 1 ]; then
        cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DBUILD_PNG=OFF \
        -DBUILD_TIFF=OFF \
        -DBUILD_TBB=OFF \
        -DBUILD_JPEG=OFF \
        -DBUILD_JASPER=OFF \
        -DBUILD_ZLIB=OFF \
        -DBUILD_EXAMPLES=ON \
        -DBUILD_opencv_java=OFF \
        -DBUILD_opencv_python2=ON \
        -DBUILD_opencv_python3=OFF \
        -DWITH_OPENCL=OFF \
        -DWITH_OPENMP=OFF \
        -DWITH_FFMPEG=ON \
        -DWITH_GSTREAMER=ON \
        -DWITH_GSTREAMER_0_10=OFF \
        -DWITH_CUDA=ON \
        -DWITH_GTK=ON \
        -DWITH_VTK=OFF \
        -DWITH_TBB=ON \
        -DWITH_1394=OFF \
        -DWITH_OPENEXR=OFF \
        -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda \
        -DCUDA_ARCH_BIN='3.0 3.5 5.0 6.0 6.2' \
        -DCUDA_ARCH_PTX="" \
        -DINSTALL_C_EXAMPLES=ON \
        -DINSTALL_TESTS=OFF \
        -DOPENCV_TEST_DATA_PATH=/home/diana1/opencv_extra/testdata \
        -DOPENCV_EXTRA_MODULES_PATH=/home/diana1/opencv_contrib/modules \
        ../opencv
    fi

    prompt_yn_question "OpenCV: Do you want to run Makefiles for OpenCV? (It may take some time) [y/n]"
    ret=$?
    if [ "$ret" -eq 1 ]; then
        make -j7 VERBOSE=1
    fi
    prompt_yn_question "OpenCV: Do you want to install OpenCV? (It make take some time) [y/n]"
    ret=$?
    if [ "$ret" -eq 1 ]; then
        sudo make install
    fi

    cd ..   # Exit build_opencv
    cd ..   # Exit OpenCV
fi

# Point Cloud Library
# prompt_yn_question "Do you want to install Point Cloud Library? [y/n]"
# ret=$?
# if [ "$ret" -eq 1 ]; then
#    sudo add-apt-repository ppa:v-launchpad-jochen-sprickerhof-de/pcl
#    sudo apt update
#    sudo apt install libpcl1.7 -y
# fi

exit 0
