FROM centos:7

RUN yum -y install centos-release-scl epel-release && \
    yum -y install bzip2 clang-analyzer cloc cmake cmake3 cppcheck devtoolset-6 doxygen findutils gcc gcc-c++ git graphviz \
        libpcap-devel lcov make mpich-3.2-devel python2-pip python-dev rh-python35 valgrind vim-common autoconf automake \
        libtool perl fuse fuse-libs fuseiso gvfs-fuse dkms dkms-fuse squashfs-tools && \
    yum -y autoremove && \
    yum clean all

RUN pip install --force-reinstall pip==9.0.3 && \
    pip install conan==1.9.1 coverage==4.4.2 flake8==3.5.0 gcovr==3.4 && \
    rm -rf /root/.cache/pip/*

ENV CONAN_USER_HOME=/conan

RUN mkdir $CONAN_USER_HOME && \
    conan

COPY files/registry.txt $CONAN_USER_HOME/.conan/

COPY files/default_profile $CONAN_USER_HOME/.conan/profiles/default

RUN conan install cmake_installer/3.10.0@conan/stable

RUN git clone https://github.com/ess-dmsc/build-utils.git && \
    cd build-utils && \
    git checkout c05ed046dd273a2b9090d41048d62b7d1ea6cdf3 && \
    scl enable devtoolset-6 -- make install

RUN adduser jenkins
RUN chown -R jenkins $CONAN_USER_HOME/.conan
RUN groupadd fuse
RUN usermod -a -G fuse jenkins

USER jenkins

WORKDIR /home/jenkins
