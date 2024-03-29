FROM centos:7

RUN yum -y install centos-release-scl epel-release && \
    yum -y install jq python36 && \
    yum -y autoremove && \
    yum clean all

RUN python3.6 -m pip install --upgrade pip && \
    python3.6 -m pip install yq && \
    rm -rf /root/.cache/pip/*

# Read package list for yum and pip from file. The list is kept in a separate
# file so we can also use it to configure other servers.
COPY files/packages.yml .

# Use yq to convert the list of packages from the YAML file into a
# whitespace-separated list, and sed to remove single quotes from around the
# package names.
RUN yum -y install $(yq -r '.yum_packages | @sh' packages.yml | sed -e "s/'//g") && \
    yum -y autoremove && \
    yum clean all

RUN python3.6 -m pip install $(yq -r '.pip_packages | @sh' packages.yml | sed -e "s/'//g") && \
    rm -rf /root/.cache/pip/*

ENV CONAN_USER_HOME=/conan

RUN mkdir $CONAN_USER_HOME && \
    conan

RUN git clone http://github.com/ess-dmsc/conan-configuration.git && \
    cd conan-configuration && \
    git checkout 5b1a947b11852a2022e8b81755a731ca4b25cdcd && \
    cd .. && \
    conan config install conan-configuration

COPY files/default_profile $CONAN_USER_HOME/.conan/profiles/default

RUN git clone https://github.com/linux-test-project/lcov.git && \
    cd lcov && \
    git checkout v1.14 && \
    scl enable devtoolset-11 -- make install

# Allows us to use "cmake" command for v 3.x for consistency with our other linux images.
RUN ln -s /usr/bin/cmake3 /usr/bin/cmake

RUN adduser jenkins
RUN chown -R jenkins $CONAN_USER_HOME/.conan
RUN conan config set general.revisions_enabled=True
RUN groupadd fuse
RUN usermod -a -G fuse jenkins

USER jenkins

COPY files/install_pyenv.sh /home/jenkins/install_pyenv.sh

RUN bash /home/jenkins/install_pyenv.sh && \
    rm /home/jenkins/install_pyenv.sh

ENV PYENV_ROOT="/home/jenkins/.pyenv"
ENV PATH="${PATH}:$PYENV_ROOT/bin"

RUN pyenv install 3.7
RUN pyenv install 3.8
RUN pyenv install 3.9
RUN CPPFLAGS=-I/usr/include/openssl11 \
    LDFLAGS=-L/usr/lib64/openssl11 \
    pyenv install 3.10

WORKDIR /home/jenkins
