FROM balenalib/raspberrypi4-64-debian

RUN apt-get update && apt-get install git \
    python3.8 \
    python3.8-dev \
    python3-setuptools \
    gcc \
    libtinfo-dev \
    zlib1g-dev \
    build-essential \
    cmake \
    libedit-dev \
    libxml2-dev \
    cmake \
    llvm-10 \
    libopenblas-dev \
    llvm-10-dev \
    libllvm10 \
    llvm-10-runtime

RUN git clone --recursive https://github.com/apache/tvm tvm

WORKDIR /tvm

RUN mkdir -p build

WORKDIR /tvm/build

COPY ./config.cmake /tvm/build/

RUN cmake .. && make -j 8

RUN sudo apt-get install python3-pip build-essential python-dev

RUN python3 -m pip install numpy

WORKDIR /tvm/python

RUN python3 gen_requirements.py

RUN python3 -m pip install -r requirements/core.txt

RUN python3 setup.py bdist_wheel

ENTRYPOINT [ "/bin/bash" ]
