FROM centos:7

RUN yum -y install centos-release-scl epel-release && \
    yum -y install bzip2 clang-analyzer cloc cmake3 cppcheck devtoolset-8 doxygen findutils gcc gcc-c++ git graphviz \
        flex make mpich-3.2-devel python36 python36-devel python36-pip valgrind vim-common autoconf automake \
        libtool perl fuse fuse-libs fuseiso gvfs-fuse dkms dkms-fuse squashfs-tools openssl-devel mesa-libGL \
        qt5-qtbase-devel ninja-build && \
    yum -y autoremove && \
    yum clean all

RUN python3.6 -m pip install --upgrade pip && \
    python3.6 -m pip install conan==1.22.2 coverage==4.4.2 flake8==3.5.0 gcovr==4.1 && \
    rm -rf /root/.cache/pip/*

ENV CONAN_USER_HOME=/conan

RUN mkdir $CONAN_USER_HOME && \
    conan

RUN conan config install http://github.com/ess-dmsc/conan-configuration.git

COPY files/default_profile $CONAN_USER_HOME/.conan/profiles/default

RUN git clone https://github.com/ess-dmsc/build-utils.git && \
    cd build-utils && \
    git checkout c05ed046dd273a2b9090d41048d62b7d1ea6cdf3 && \
    scl enable devtoolset-8 -- make install

RUN git clone https://github.com/linux-test-project/lcov.git && \
    cd lcov && \
    git checkout v1.14 && \
    scl enable devtoolset-8 -- make install

# Calling cmake will use cmake v3.x
# Allows us to use "cmake" command for v 3.x for consistency with our other linux images
RUN ln -s /usr/bin/cmake3 /usr/bin/cmake

# Use ninja-build as ninja for consistency with our other linux images
ln /usr/bin/ninja-build /usr/bin/ninja
    
RUN adduser jenkins
RUN chown -R jenkins $CONAN_USER_HOME/.conan
RUN groupadd fuse
RUN usermod -a -G fuse jenkins

USER jenkins

WORKDIR /home/jenkins
