# cleanup
killall mongod
rm -rf /data/dbs/*
gcc -o mlock mlock.c
sudo mkdir /data/m; sudo chown ec2-user /data/m

rm -f /media/ephemeral1/my80
rm -f /media/ephemeral1/pg12
ln -s /media/ephemeral1/my8018 /media/ephemeral1/my80
ln -s /media/ephemeral1/pg120 /media/ephemeral1/pg12

sudo yum install -y python3
sudo python3 -m pip install pymongo
sudo yum install -y mysql-devel python3-devel
#sudo yum install -y MySQL-python
#sudo yum install -y MySQL-python3
#sudo yum install -y libmysqlclient-dev
#sudo yum install -y python3-devel
#sudo python3 -m pip install mysqlclient
sudo pip3 install mysqlclient
sudo pip3 install psycopg2-binary
sudo yum install -y openssl11-libs
sudo yum install -y libzstd-1.3.3
sudo yum install -y ncurses-compat-libs
sudo rm -f /etc/my.cnf /etc/mysql/my.cnf

# install jemalloc
cd /media/ephemeral1
rm -rf jemalloc-5.2.1*
wget https://github.com/jemalloc/jemalloc/releases/download/5.2.1/jemalloc-5.2.1.tar.bz2
bunzip2 jemalloc-5.2.1.tar.bz2
tar xvf jemalloc-5.2.1.tar
cd jemalloc-5.2.1
./configure --prefix=/usr > o.cf 2> e.cf
make -j4 > o.m 2> e.m
sudo make install

# install things needed to compile MySQL8 and MyRocks
sudo yum install -y cmake3
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y numactl-devel
sudo yum install -y libedit-devel
sudo yum install -y cmake gcc-c++ bzip2-devel libaio-devel bison zlib-devel snappy-devel 
sudo yum install -y gflags-devel readline-devel ncurses-devel openssl-devel lz4-devel gdb git libzstd-devel

sudo yum install -y pypy
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
pypy get-pip.py
pypy -m pip install pymongo

#alias mypypy3="LD_LIBRARY_PATH=/media/ephemeral1/pypy-36-al2/site-packages/psycopg2 /media/ephemeral1/pypy-36-al2/bin/pypy3"

exit 0

sudo rm /data
sudo ln -s /media/ephemeral0 /data
sudo mkdir /data/m; sudo chown ec2-user /data/m
nohup numactl --interleave=all ./mlock 40 8 >& o.mlock &
dd if=/dev/zero of=/media/ephemeral0 bs=1MB count=340000 
