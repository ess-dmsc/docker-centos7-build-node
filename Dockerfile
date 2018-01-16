FROM centos:7

RUN yum -y install epel-release && \
    yum -y install bzip2 clang-analyzer cloc cmake cmake3 cppcheck doxygen findutils gcc gcc-c++ git graphviz lcov make mpich-3.2-devel python2-pip valgrind vim-common && \
    yum -y autoremove && \
    yum clean all

RUN pip install conan==1.0.2 coverage==4.4.2 flake8==3.5.0 gcovr==3.3 && \
    rm -rf /root/.cache/pip/*

ENV CONAN_USER_HOME=/conan

RUN mkdir $CONAN_USER_HOME && \
    conan

COPY files/registry.txt $CONAN_USER_HOME/.conan/

COPY files/default_profile $CONAN_USER_HOME/.conan/profiles/default

RUN git clone https://github.com/ess-dmsc/utils.git && \
    cd utils && \
    git checkout 3f89fad6e801471baabee446ba4d327e54642b32 && \
    make install

RUN adduser jenkins

RUN chown -R jenkins $CONAN_USER_HOME/.conan

USER jenkins

WORKDIR /home/jenkins
