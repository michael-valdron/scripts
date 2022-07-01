FROM mcr.microsoft.com/windows:20H2

ARG target
ARG script

USER root

COPY ${target} /target

WORKDIR /target

RUN powershell.exe -executionpolicy bypass ${script}

WORKDIR /

RUN rm -rf /target
