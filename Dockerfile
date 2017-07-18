FROM centos:7.2.1511

RUN yum install -y epel-release

RUN yum install -y clang-analyzer cloc cmake cmake3 cppcheck doxygen gcc \
        gcc-c++ git graphviz lcov make python2-pip valgrind

RUN pip install conan coverage flake8 gcovr

ENV CONAN_USER_HOME=/conan

RUN mkdir /conan && \
    conan

RUN yum -y update && yum clean all

COPY files/registry.txt $CONAN_USER_HOME/.conan/
