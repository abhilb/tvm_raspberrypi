FROM balenalib/raspberrypi4-64-debian

RUN apt-get update && apt-get install git \
    python3 \
    python3-dev \
    python3-setuptools \
    gcc \
    libtinfo-dev \
    zlib1g-dev \
    build-essential \
    cmake \
    libedit-dev \
    libxml2-dev \
    cmake \
    llvm-11 \
    libopenblas-dev \
    llvm-11-dev \
    libllvm11 \
    llvm-11-runtime

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

RUN mkdir -p /wheels

CMD ["cp", "-r", "/tvm/python/dist/", "/wheels"]
