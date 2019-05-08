FROM centos:7

RUN yum -y install centos-release-scl epel-release && \
    yum -y install bzip2 clang-analyzer cloc cmake3 cppcheck devtoolset-6 doxygen findutils gcc gcc-c++ git graphviz \
        flex lcov make mpich-3.2-devel python36 python36-devel python36-pip valgrind vim-common autoconf automake \
        libtool perl fuse fuse-libs fuseiso gvfs-fuse dkms dkms-fuse squashfs-tools openssl-devel mesa-libGL qt5-qtbase-devel && \
    yum -y autoremove && \
    yum clean all

RUN pip3.6 install --upgrade pip && \
    pip3.6 install conan==1.15.0 coverage==4.4.2 flake8==3.5.0 gcovr==4.1 && \
    rm -rf /root/.cache/pip/*

ENV CONAN_USER_HOME=/conan

RUN mkdir $CONAN_USER_HOME && \
    conan

COPY files/remotes.json $CONAN_USER_HOME/.conan/
COPY files/default_profile $CONAN_USER_HOME/.conan/profiles/default

RUN git clone https://github.com/ess-dmsc/build-utils.git && \
    cd build-utils && \
    git checkout c05ed046dd273a2b9090d41048d62b7d1ea6cdf3 && \
    scl enable devtoolset-6 -- make install

# Calling cmake will use cmake v3.x
# Allows us to use "cmake" command for v 3.x for consistency with our other linux images
RUN ln -s /usr/bin/cmake3 /usr/bin/cmake
    
RUN adduser jenkins
RUN chown -R jenkins $CONAN_USER_HOME/.conan
RUN groupadd fuse
RUN usermod -a -G fuse jenkins

USER jenkins

WORKDIR /home/jenkins
