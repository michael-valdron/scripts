FROM archlinux:base

ARG target
ARG script
ARG args=

ENV SCRIPT_TESTING=1

USER root

COPY ${target} /target

WORKDIR /target

RUN sh ${script} "${args}"

WORKDIR /

RUN rm -rf /target
