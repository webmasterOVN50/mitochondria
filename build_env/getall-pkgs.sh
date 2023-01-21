echo "Dist_Root: ${DISK_ROOT:?}"
echo "LFS: ${LFS:?}"

mkdir -p $LFS/sources

for f in $(cat $DISK_ROOT/build_env/build_env_list)
do
        bn=$(basename $f)

        if ! test -f $LFS/sources/$bn ; then
           wget $f -O $LFS/sources/$bn
        fi

done;
