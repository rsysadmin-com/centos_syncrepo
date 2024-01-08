# centos_syncrepo
This little script will let you synchronize several CenOS repositories, including EPEL and REMI, on one single server so you can point your CentOS 6, 7 and 8 servers to it.

## usage

```
./centos_syncrepo.sh 
Usage: centos_syncrepo.sh <version>
        where version can be 6, 7 or 8

        for example:
                centos_syncrepo.sh 8 <- to synchronize CentOS 8 repositories
                centos_syncrepo.sh 7 <- to synchronize CentOS 7 repositories
                centos_syncrepo.sh 6 <- to synchronize CentOS 6 repositories

```

## what if I do not want to synchronize everything?
Just list it on the proper `exclude-file` to avoid downloading unneeded stuff, like ISO images.  

Take a look at the example file:

```
cloud/
configmanagement/
cr/
fasttrack/
isos/
messaging/
opstools/
storage/
virt/
```

If you modify its filename you should also do the necessary changes in the script's source code.

## what if a particular version of CentOS isn't supported?
That might happen, as I coded this script when I was working with CenOS servers some time ago and the latest version was 8. 

Feel free to create a PR with your modifications.


## disclaimer
this script is published on an "AS IS" basis. The author is not to be held responsible for any dameges its use or misuse may cause.
