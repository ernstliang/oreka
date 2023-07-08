FROM ubuntu:focal
LABEL maintainer="Ufintek"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y libcap2 libpcap0.8 libsndfile1 libapr1 libspeex1 liblog4cxx10v5 libace-6.4.5 libopus0 libxerces-c3.2 libssl1.1 libdw1 libunwind8 && rm -rf /var/lib/apt/lists/* 

