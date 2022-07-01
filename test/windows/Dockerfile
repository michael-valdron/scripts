FROM mcr.microsoft.com/windows/server:ltsc2022

ARG target
ARG script

COPY ${target} /target

WORKDIR /target

RUN powershell.exe -executionpolicy bypass ${script}

WORKDIR /

RUN powershell.exe -Command Remove-Item -Recurse /target
