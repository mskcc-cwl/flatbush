# use the ubuntu base image
FROM ubuntu:18.04

MAINTAINER Tobias Rausch rausch@embl.de

# install required packages
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    g++ \
    gfortran \
    git \
    hdf5-tools \
    libboost-date-time-dev \
    libboost-program-options-dev \
    libboost-system-dev \
    libboost-filesystem-dev \
    libboost-iostreams-dev \
    libbz2-dev \
    libhdf5-dev \
    libncurses-dev \
    liblzma-dev \
    zlib1g-dev \
    locales \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# set environment
ENV BOOST_ROOT /usr
ENV DEBIAN_FRONTEND=noninteractive 

# install alfred
RUN cd /opt \
    && git clone --recursive https://github.com/tobiasrausch/alfred.git \
    && cd /opt/alfred/ \
    && make STATIC=1 all \
    && make install

# install R packages

RUN apt-get update && apt-get install -y r-base-core r-base-dev \
    ## install R dependencies
    && R -e "install.packages('ggplot2', dependencies=TRUE, repos='http://cran.rstudio.com/')" 

RUN apt-get install locales \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8

# Add Alfred to PATH
ENV PATH="/opt/alfred/bin:${PATH}"
