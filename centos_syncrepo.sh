#!/bin/bash

# centos_syncrepo.sh
#
# 20200811 - martinm@rsysadmin.com - initial version
#
# simple script to automatically sync CentOS repositories:
#   - official CentOS repositories
#   - EPEL repositories
#   - REMI repositories
#
# usage: centos_syncrepo.sh n
#         where n = CentOS version (i.e.: 6, 7, 8)
#         for example: centos_syncrepo.sh 8
#         this will synchronize CentOS 8 repositories only.
#
# this script relies on exclude-files located in ../etc/ and they should
# list files or directories to be exluded, one per line
#



# useful functions come here
function usage() {
        cat << EOF
Usage: $(basename $0) <version>
        where version can be 6, 7 or 8

        for example:
                $(basename $0) 8 <- to synchronize CentOS 8 repositories
                $(basename $0) 7 <- to synchronize CentOS 7 repositories
                $(basename $0) 6 <- to synchronize CentOS 6 repositories

EOF
        exit 1
}

function check_status() {
        if [[ $? -eq 0 ]]
        then
                echo -e "[ PASS ]\n"
        else
                echo -e "[ FAIL ]\n"
        fi
}

# select CentOS version
vers=$1

if [[ -z $vers ]]
then
        usage
fi

# check if we are already running
lock_file=/var/lock/subsys/reposync_is_running_$vers
if [ -f $lock_file ]
then
        exit 2
fi


# define a few useful variables
repo_dir=/repos/centos/$vers                                                    # location of the local repositories
repo_url=rsync://linuxsoft.cern.ch/centos/$vers/                                # URL for CentOS RPMs
repo_epel=rsync://pkg.adfinis-sygroup.ch/fedora-epel/$vers                      # URL for EPEL RPMs
repo_remi=rsync://mirror.23media.com/remi/enterprise/$vers/remi/x86_64/         # URL for REMI RPMs
repo_exc=/usr/local/etc/exclude_centos${vers}_repos.txt                         # location of exclude-files ('cos you don't need everything...)


# check that the directory where the local repository will reside is there
# if it is not, bail out.
if [ ! -d $repo_dir ]
then
        echo "ERROR - $repo_dir does not exist."
        exit 1
fi

# create lock file to avoid multiple instances of the same sync process
touch $lock_file

# sync CentOS repositories
echo "== Synchronizing CentOS $vers repositories."
echo "== This operation usually will take a lot of time."
echo -e "== STATUS: \c"
rsync  -aqSHP --exclude-from=$repo_exc $repo_url "$repo_dir"
check_status

# Download CentOS repository key
if [ ! -r $repo_dir/RPM-GPG-KEY-CentOS-Official ]
then
        echo -e "== Downloading repository key... \c"
        wget -qP $repo_dir https://www.centos.org/keys/RPM-GPG-KEY-CentOS-Official
        check_status
fi


# sync EPEL repositories
if [ ! -d $repo_dir/epel ]
then
        echo -e "== Creating $repo_dir/epel ... \c"
        mkdir $repo_dir/epel
        check_status
fi

if [ $vers = 8 ]
then
        echo "== Synchronizing EPEL repository for CentOS $vers."
        echo "== This operation will also take a lot of time."
        echo -e "== STATUS: \c"
        rsync -aqSHP $repo_epel/Everything/x86_64 "$repo_dir/epel"
        check_status

elif [ $vers = 7 ]
then
        echo "== Synchronizing EPEL repository for CentOS $vers."
        echo "== This operation will also take a lot of time."
        echo -e "== STATUS: \c"
        rsync -aqSHP $repo_epel/x86_64 "$repo_dir/epel"
        check_status
fi

# sync REMI repositories
if [ ! -d $repo_dir/remi ]
then
        echo -e "== Creating $repo_dir/remi ... \c"
        mkdir $r  epo_dir/remi
        check_status
fi

echo "== Synchronizing REMI repository for CentOS $vers."
echo "== This operation will also take a lot of time."
echo -e "== STATUS: \c"
rsync  -aqSHP $repo_remi "$repo_dir/remi"
check_status

echo -e "== Fixing ownership of downloaded files... \c"
chown -R nginx.nginx $repo_dir
check_status

# unlock and exit
echo -e "== Removing lock file and exiting... \c"
rm -f $lock_file
check_status
