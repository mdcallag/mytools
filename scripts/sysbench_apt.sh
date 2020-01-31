#!/bin/bash

# Install pre-requisites to execute scripts in this repo.
# This file is for Ubuntu

set -e

sudo apt -y install build-essential
sudo apt -y install strace strace64 flex bison cmake pkg-config gettext automake autoconf gdb libtool binutils libaio-dev

# Install sysbench
sudo apt -y install libmysqlclient-dev libssl-dev
sudo apt -y install libpq-dev
wget https://github.com/akopytov/sysbench/archive/master.zip
unzip master.zip >& o.unzip
cd sysbench-master
./autogen.sh >& o.ag
./configure --with-mysql --with-pgsql >& o.cnf
make >& o.mk
sudo make install 
cd ..

# Install Lua and dependencies
LUAVER="5.3"
echo Install Lua $LUAVER and dependencies
sudo apt -y install lua${LUAVER} liblua${LUAVER}-dev luarocks libbson-dev
sudo apt -y install libssl-dev libsasl2-dev

echo Install mongo-c-driver
curl -L -O https://github.com/mongodb/mongo-c-driver/releases/download/1.16.0/mongo-c-driver-1.16.0.tar.gz
tar xzf mongo-c-driver-1.16.0.tar.gz
cd mongo-c-driver-1.16.0
mkdir -p cmake-build
cd cmake-build
cmake -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF .. >& o.cm
make >& o.mk
sudo make install 
cd ../..

echo export LD_LIBRARY_PATH=/usr/local/lib64/:$LD_LIBRARY_PATH >> ~/sysbench.bashrc
bash ~/sysbench.bashrc
echo $LD_LIBRARY_PATH


OPT=""
if [ $(whoami) != "root" ]
then
    OPT="$OPT --local"
fi

#luarocks install $OPT mongorover
echo Install mongorover and more
rm -rf mongorover || true
git clone https://github.com/mongodb-labs/mongorover.git
cd mongorover
luarocks make $OPT mongorover*.rockspec >& o.mk
cd ..

luarocks install $OPT https://raw.githubusercontent.com/jiyinyiyong/json-lua/master/json-lua-0.1-3.rockspec
luarocks install $OPT penlight

# I don't know what's out of sync with the mongorover path here, but this fixed it
if [ $(whoami) != "root" ]
then
    if [ -L ~/.luarocks/lib64 ] ; then 
        echo lib64 link exists for luarocks
    else
        ln -s ~/.luarocks/lib ~/.luarocks/lib64
    fi
else
    mkdir -p /usr/local/lib/lua/5.1/
    ln -s /usr/lib64/lua/5.1/mongo_module.so /usr/local/lib/lua/${LUAVER}/mongo_module.so
fi


