FROM debian:10-slim

ARG target
ARG script

ENV SCRIPT_TESTING=1

USER root

COPY ${target} /target

WORKDIR /target

RUN sh ${script}

WORKDIR /

RUN rm -rf /target
