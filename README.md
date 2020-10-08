# docker-centos7-build-node

Dockerfile for a CentOS 7 build node


## Building

    $ docker build -t <tag> <path_to_dockerfile>

To create the official container image, substitute `<tag>` with
_screamingudder/centos7-build-node:<version>_.

## Uploading image

You might have to login using your docker credentials first by executing:

```
docker login
```

After that, simply run:

```
docker push <tag>
```

## Using GCC 8

GCC 8 can be used by using `scl enable devtoolset-8 <command>`. The default
Conan profile is configured to use GCC 8.


## Python 3

Python 3.6 is available through `python3.6`.


## Build ess-dmsc repos on CentOS
This image is based on the Dockerfile with some additional commands and files.
When run it clones the repo and branch specified as arguments and builds the
project and attempts to build the unit_tests target.

To create the image:

```
./mkbuildimg
```
