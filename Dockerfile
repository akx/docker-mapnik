FROM ubuntu:18.10

ENV DEBIAN_FRONTEND noninteractive

# Use a faster mirror
RUN sed -i 's#http://archive.ubuntu.com/ubuntu#mirror://mirrors.ubuntu.com/mirrors.txt#g' /etc/apt/sources.list

# Prerequisites and runtimes
COPY setup-node.sh /tmp/setup-node.sh
RUN bash /tmp/setup-node.sh && rm /tmp/setup-node.sh
RUN apt-get upgrade -y
RUN apt-get install -y --no-install-recommends \
	build-essential \
	curl \
	git \
	libboost-dev \
	libboost-filesystem-dev \
	libboost-program-options-dev \
	libboost-python-dev \
	libboost-regex-dev \
	libboost-system-dev \
	libboost-thread-dev \
	libcairo-dev \
	libfreetype6-dev \
	libgdal-dev \
	libharfbuzz-dev \
	libicu-dev \
	libpng-dev \
	libproj-dev \
	libsqlite3-dev \
	libtiff5-dev \
	libxml2-dev \
	nodejs \
	postgresql-contrib \
	python-cairo-dev \
	python-dev \
	python-pip \
	python-setuptools \
	python-wheel \
	python3-dev \
	python3-pip \
	python3-setuptools \
	python3-wheel \
	software-properties-common \
	sudo \
	unzip

# Mapnik
ENV MAPNIK_COMMIT 7d1bfaeb4b20b6ef2a680cd648c50851c5854e0f
RUN git clone https://github.com/mapnik/mapnik.git /opt/mapnik
RUN cd /opt/mapnik && \
	git checkout ${MAPNIK_COMMIT} && \
	git submodule update --init --recursive --remote
RUN cd /opt/mapnik && python scons/scons.py configure
RUN cd /opt/mapnik && make JOBS=2 && make install JOBS=2

# Python Bindings
ENV PYTHON_MAPNIK_COMMIT bd5137acc9c3358f24c3aee1d90347c8349a4eb3
RUN mkdir -p /opt/python-mapnik && curl -L https://github.com/mapnik/python-mapnik/archive/${PYTHON_MAPNIK_COMMIT}.tar.gz | tar xz -C /opt/python-mapnik --strip-components=1
RUN cd /opt/python-mapnik && python2 setup.py install && python3 setup.py install && rm -r /opt/python-mapnik/build

# Node Bindings (which don't work)
#RUN apt-get install -y --no-install-recommends clang
#ENV NODE_MAPNIK_COMMIT 3fecdfa88189ba00d4ac6a2600822c5ad3f3f5d5
#RUN git clone https://github.com/mapnik/node-mapnik.git /opt/node-mapnik
#RUN cd /opt/node-mapnik && git checkout ${NODE_MAPNIK_COMMIT} && git submodule update --init --recursive --remote
#RUN cd /opt/node-mapnik && CXX=clang++ CC=clang make release_base && npm link

# Tests
RUN mkdir -p /opt/demos
COPY world.py /opt/demos/world.py
COPY 110m-admin-0-countries.zip /opt/demos/110m-admin-0-countries.zip
RUN cd /opt/demos && unzip 110m-admin-0-countries.zip && rm 110m-admin-0-countries.zip
COPY stylesheet.xml /opt/demos/stylesheet.xml

