FROM opensuse/tumbleweed

RUN zypper --gpg-auto-import-keys --non-interactive install \
        gcc-c++ \
        make \
        cmake \
        pkgconfig \
        libboost_filesystem-devel \
        libboost_system-devel \
        libboost_thread-devel \
        gnuradio-devel \
        libosmocore-devel \
        gr-osmosdr \
        swig \
        doxygen \
        python2-devel \
        python3-docutils \
        cppunit-devel

COPY ./ /src/

WORKDIR /src/build
RUN cmake .. && \
        # The parallel build sometimes fails when the .grc_gnuradio
        # and .gnuradio directories do not exist
        mkdir $HOME/.grc_gnuradio/ $HOME/.gnuradio/ && \
        make && \
        make -j $(nproc) && \
        make install && \
        ldconfig && \
        make CTEST_OUTPUT_ON_FAILURE=1 test
