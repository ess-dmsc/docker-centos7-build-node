# docker-centos7-build-node

Dockerfile for a CentOS 7 build node


## Building and pushing the image

Jenkins will automatically build and push the image to the container registry.
When making changes, create a new branch and update the version before you
push. The image pushed from the branch build will have the suffix `-dev` added
to its name; the `-pr` suffix is added to pull request builds. After merging to
master, the image with the standard name will be pushed. The master branch
builds don't allow overwriting already existent images.


## Using GCC 11

GCC 11 can be used by running `scl enable devtoolset-11 <command>`. The default
Conan profile is configured to use GCC 11.


## Python 3

Python 3.6 is available through `python3.6`; Python 3.8 can be used by running
`scl enable rh-python38 <command>`.


## Build ess-dmsc repos on CentOS
This image is based on the Dockerfile with some additional commands and files.
When run it clones the repo and branch specified as arguments and builds the
specified targets. If no targets are specified the 'all' target is used.

### To build the image:

```
> ./mkbuildimg
```

### To run
The syntax for running is
```
> docker run -i -t buildcentos repo branch target1 target2 ...
```
here is a working example:

```
> docker run -i -t buildcentos event-formation-unit master all unit_tests
```

### Custom build command
If you want a custom build command for your project put a bash script in your
PATH that looks like this

```
> cat buildefu
#!/bin/bash

branch=$1

docker run -i -t buildcentos event-formation-unit $branch all unit_tests
```

then from any directory you can start the CentOS build
```
> buildefu issue_233
```
