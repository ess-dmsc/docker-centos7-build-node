**This build node image has been deprecated — use
https://github.com/ess-dmsc/docker-centos7-gcc6-build-node instead.**

# docker-centos7-build-node

Dockerfile for a CentOS 7 build node


## Building

    $ docker build -t <tag> <path_to_dockerfile>

To create the official container image, substitute `<tag>` with
_essdmscdm/centos7-build-node:<version>_.


## Using GCC 6

GCC 6 can be used by using `scl enable devtoolset-6 <command>`. The default
Conan profile is configured to use GCC 6.


## Python 3

Python 3.5 is available with `scl enable rh-python35 <command>`. Note that Conan
is installed for Python 2.
