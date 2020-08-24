# centos_syncrepo
This little script will let you synchronize several CenOS repositories, includind EPEL and REMI, on one single server so you can point your CentOS 6, 7 and 8 servers to it.

## usage
it is very easy:
./centos_syncrepo.sh <version>

for example: ./centos_syncrepo.sh 8   <-- this will synchronize the CentOS 8 repositories for you, including EPEL and REMI.


## what if I do not want to synchronize everything?
Just list it on the proper exclude-file to avoid downloading unneeded stuff, like ISO images.  Take a look at the example file. If you modify its filename you should also do the necessary changes in the script source code.


## disclaimer
this script is published on an "AS IS" basis. The author is not to be held responsible for any dameges its use or misuse may cause.
