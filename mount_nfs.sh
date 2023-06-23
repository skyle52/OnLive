#/bin/bash
mkdir -p /var/www/data
chown -R www-data:www-data /var/www/data

mkdir -p /data/gluster/fvod
mkdir -p /data/gluster/originfile
mkdir -p /data/gluster/remove
mkdir -p /data1/gluster

chown www-data /data/gluster/fvod
chown www-data /data/gluster/originfile
chown www-data /data/gluster/remove
chown www-data /data1/gluster

mount -t nfs 10.74.10.20:/gpfs/nfs_0/onlive_nfs_prod /var/www/data
mount -t nfs -o vers=3,noatime,nodiratime,nolock 10.74.10.20:/gpfs/nfs_1/fmp4 /data/gluster/fvod
mount -t nfs -o vers=3,noatime,nodiratime,nolock 10.74.10.20:/gpfs/nfs_1/rmp4 /data1/gluster
mount -t nfs -o vers=3,noatime,nodiratime,nolock 10.74.10.20:/gpfs/nfs_1/ucc /data/gluster/originfile
mount -t nfs -o vers=3,noatime,nodiratime,nolock 10.74.10.20:/gpfs/nfs_1/remove /data/gluster/remove


echo "10.74.10.20:/gpfs/nfs_0/onlive_nfs_prod /var/www/data   nfs     defaults        0       0" >> /etc/fstab
echo "10.74.10.20:/gpfs/nfs_1/fmp4 /data/gluster/fvod nfs vers=3,noatime,nodiratime,nolock 0 0" >> /etc/fstab
echo "10.74.10.20:/gpfs/nfs_1/ucc /data/gluster/originfile nfs vers=3,noatime,nodiratime,nolock 0 0" >> /etc/fstab
echo "10.74.10.20:/gpfs/nfs_1/remove /data/gluster/remove nfs vers=3,noatime,nodiratime,nolock 0 0" >> /etc/fstab
echo "10.74.10.20:/gpfs/nfs_1/rmp4 /data1/gluster nfs vers=3,noatime,nodiratime,nolock 0 0" >> /etc/fstab
