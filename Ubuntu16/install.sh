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
sudo apt install openssh-server wget curl vim tree net-tools cmake git -y
sudo apt-get update

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
    apm install -c --version atom-ide-ui atom-clock autosave-onchange language-cmake language-doxygen markdown-writer language-make
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

#prompt_yn_question "Do you want to install Point Cloud Library? [y/n]"
#ret=$?
#if [ "$ret" -eq 1 ]; then
#    sudo add-apt-repository ppa:v-launchpad-jochen-sprickerhof-de/pcl
#    sudo apt update
#    sudo apt install libpcl1.7 -y
#fi

exit 0
