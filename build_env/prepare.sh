export DISK_ROOT=/home/ubuntu/projects/mitochondria/
export LFS=$DISK_ROOT/build_env/build_root

echo "Dist_Root: ${DISK_ROOT:?}"
echo "LFS: ${LFS:?}"

mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}

for i in bin lib sbin; do
  ln -sv usr/$i $LFS/$i
done

case $(uname -m) in
  aarch64) mkdir -pv $LFS/lib64 ;;
esac

mkdir -pv $LFS/tools

if ! test $(id -u lfs) ; then
groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs

passwd lfs

chown -v lfs $LFS/{usr{,/*},lib,var,etc,bin,sbin,tools,sources}
case $(uname -m) in
  aarch64) chown -v lfs $LFS/lib64 ;;
esac

su - lfs

dbhome=$(eval echo "-lfs")

cat > $dbhome/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

cat > $dbhome/.bashrc << EOF
set +h
umask 022
LFS=$LFS
DISK_ROOT=$DISK_ROOT
EOF

cat >> $dbhome/.bashrc << "EOF"
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE
export MAKEFLAGS='-j$(nproc)'
EOF

source ~/.bash_profile

fi
