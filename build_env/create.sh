export DISK_ROOT=/home/ubuntu/projects/mitochondria/
export LFS=$DISK_ROOT/build_env/build_root

echo "Dist_Root: ${DISK_ROOT:?}"
echo "LFS: ${LFS:?}"

if ! test $(whoami) == "lfs" ; then
    echo "Must run as lfs!"
    exit -l
fi



echo "Creating build environment...."
