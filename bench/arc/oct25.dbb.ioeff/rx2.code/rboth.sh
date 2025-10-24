
bash x3.sh 1 no 600 c8r16 40000000 1000000000 iodir_none
mv res.iodir_none res.iodir_none.1u

exit

bash x3.sh 6 no 600 c8r16 40000000 1000000000 iodir_none
mv res.iodir_none res.iodir_none.6u

exit

bash x3.sh 1 no 600 c8r32 40000000 400000000 iodir_none 
mv res.iodir_none res.iodir_none.lru

USE_BEST_CACHE=true bash x3.sh 1 no 600 c8r32 40000000 400000000 iodir_none 
mv res.iodir_none res.iodir_none.hyper

