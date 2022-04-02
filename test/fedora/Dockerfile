FROM fedora:latest

ARG target
ARG script

USER root

COPY ${target} /target

WORKDIR /target

RUN sh ${script}

WORKDIR /

RUN rm -rf /target
