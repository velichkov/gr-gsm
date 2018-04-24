FROM centos:7

RUN yum install -y \
        https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

RUN yum install -y \
        gcc-c++ \
        make \
        cmake3 \
        pkgconfig \
        boost-devel \
        gnuradio-devel \
        libosmocore-devel \
        gr-osmosdr \
        swig \
        doxygen \
        python2-docutils \
        cppunit-devel

COPY ./ /src/

RUN yum install -y patch && \
    patch -p0 < /src/tests/dockerfiles/CentOS_7_pygtk2.patch

RUN cat /etc/redhat-release
RUN rpm -qa

WORKDIR /src/build
RUN cmake3 -DENABLE_GRGSM_LIVEMON=OFF .. && \
        # The parallel build sometimes fails when the .grc_gnuradio
        # and .gnuradio directories do not exist
        mkdir $HOME/.grc_gnuradio/ $HOME/.gnuradio/ && \
        make VERBOSE=1 && \
        make install && \
        ldconfig && \
        make test
