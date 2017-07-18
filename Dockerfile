FROM centos:7.2.1511

RUN yum -y install epel-release && \
    yum -y install clang-analyzer cloc cmake cmake3 cppcheck doxygen gcc \
        gcc-c++ git graphviz lcov make python2-pip valgrind && \
    yum -y autoremove && \
    yum clean all

RUN pip install conan coverage flake8 gcovr && \
    rm -rf /root/.cache/pip/*

ENV CONAN_USER_HOME=/conan

RUN mkdir /conan && \
    conan

COPY files/registry.txt $CONAN_USER_HOME/.conan/
