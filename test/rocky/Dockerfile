FROM rockylinux:8.6

ARG target
ARG script

USER root

COPY ${target} /target

WORKDIR /target

RUN sh ${script}

WORKDIR /

RUN rm -rf /target
