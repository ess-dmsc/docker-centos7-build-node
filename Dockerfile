FROM centos

RUN yum -y install epel-release && \
    yum -y install clang-analyzer cloc cmake cmake3 cppcheck doxygen gcc \
        gcc-c++ git graphviz lcov make python2-pip valgrind && \
    yum -y autoremove && \
    yum clean all

RUN pip install conan coverage flake8 gcovr && \
    rm -rf /root/.cache/pip/*

ENV CONAN_USER_HOME=/conan

RUN mkdir $CONAN_USER_HOME && \
    conan

RUN yum -y install python-devel which && \
    yum clean all && \
    cd && \
    curl -LO https://dl.bintray.com/boostorg/release/1.64.0/source/boost_1_64_0.tar.gz && \
    tar xf boost_1_64_0.tar.gz && \
    cd boost_1_64_0 && \
    ./bootstrap.sh && \
    ./b2 && \
    ./b2 install && \
    cd .. && \
    rm -rf boost_1_64_0 boost_1_64_0.tar.gz

COPY files/registry.txt $CONAN_USER_HOME/.conan/

RUN yum -y install findutils && \
    yum -y autoremove && \
    yum clean all

RUN git clone https://github.com/ess-dmsc/utils.git && \
    cp utils/clangformatdiff.sh /usr/local/bin && \
    chmod +x /usr/local/bin/clangformatdiff.sh

RUN adduser jenkins

RUN chown -R jenkins $CONAN_USER_HOME/.conan

USER jenkins

WORKDIR /home/jenkins
