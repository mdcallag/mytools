maxlev1=$1
dbgb1=$2
wbmb1=$3

maxlev2=$1
dbgb2=$2
wbmb2=$3

traindir=rpl.mxl.${maxlev1}.dbgb.${dbgb1}.wbmb.${wbmb1}
testdir=rpl.mxl.${maxlev1}.dbgb.${dbgb1}.wbmb.${wbmb1}

#python rpl_reg.py --file=o3.tsv --notdom=0 --show=0 --save=1 --model=linear --normalize=1 --augment=0 --combine=0 > m.lin.00
#python rpl_reg.py --file=o3.tsv --notdom=0 --show=0 --save=1 --model=linear --normalize=1 --augment=1 --combine=0 > m.lin.10
#python rpl_reg.py --file=o3.tsv --notdom=0 --show=0 --save=1 --model=linear --normalize=1 --augment=1 --combine=1 > m.lin.11

# python rpl_reg.py --file=o3.tsv --notdom=0 --show=0 --save=1 --model=ridge --alpha=0.1 --normalize=1 --augment=0 --combine=0 > m.linreg.00


