#!/bin/bash

# Install pre-requisites to execute scripts in this repo.
# This file for AMZN2 and Centos7.
# Note that this doesn't install MongoDB server, as it is expected to run on a separate host (in my world)

set -e

sudo yum -y groupinstall "Development tools"

# sysbench repo
curl -s https://packagecloud.io/install/repositories/akopytov/sysbench/script.rpm.sh | sudo bash

# EPEL repo (luarocks)
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
# Need to pin sysbench version because of https://github.com/akopytov/sysbench/issues/327
sudo yum -y install sysbench-1.0.17-2.el7 lua lua-devel luarocks
# For SSL (aka Atlas) to properly work, we need a never mongo c driver. Compile from source below.
#sudo yum -y install libbson mongo-c-driver libbson-devel mongo-c-driver-devel mongo-c-driver-libs cyrus-sasl-lib libdb
echo
echo
echo

sudo yum -y install cmake openssl-devel cyrus-sasl-devel

curl -L -O https://github.com/Kitware/CMake/releases/download/v3.14.4/cmake-3.14.4-Linux-x86_64.tar.gz
tar xzf cmake-3.14.4-Linux-x86_64.tar.gz
export PATH=$(pwd)/cmake-3.14.4-Linux-x86_64/bin:$PATH

curl -L -O https://github.com/mongodb/mongo-c-driver/releases/download/1.14.0/mongo-c-driver-1.14.0.tar.gz
tar xzf mongo-c-driver-1.14.0.tar.gz
cd mongo-c-driver-1.14.0
mkdir -p cmake-build
cd cmake-build
cmake -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF ..
make
sudo make install
cd ../..

echo export LD_LIBRARY_PATH=/usr/local/lib64/:$LD_LIBRARY_PATH >> .bashrc


OPT=""
if [ $(whoami) != "root" ]
then
    OPT="$OPT --local"
fi

#luarocks install $OPT mongorover
rm -rf mongorover || true
git clone https://github.com/mongodb-labs/mongorover.git
cd mongorover
luarocks make $OPT mongorover*.rockspec
cd ..

luarocks install $OPT https://raw.githubusercontent.com/jiyinyiyong/json-lua/master/json-lua-0.1-3.rockspec
luarocks install $OPT penlight

# I don't know what's out of sync with the mongorover path here, but this fixed it
if [ $(whoami) != "root" ]
then
    cd .luarocks
    ln -s lib64 lib
    cd ..
else
    mkdir -p /usr/local/lib/lua/5.1/
    ln -s /usr/lib64/lua/5.1/mongo_module.so /usr/local/lib/lua/5.1/mongo_module.so
fi
