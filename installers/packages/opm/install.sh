#!/bin/sh

OPM_FILENAME=opm-linux.tar.gz
OCP_VERSION=${OCP_VERSION:-'latest-4.12'}
OPM_DL_LOC=${OPM_DL_LOC:-'/tmp'}
OPM_INSTALL_LOC=${OPM_INSTALL_LOC:-'/usr/local/bin/opm'}

base_url=https://mirror.openshift.com/pub/openshift-v4/$(arch)/clients/ocp/${OCP_VERSION}
opm_url=${base_url}/${OPM_FILENAME}
opm_archive_loc=${OPM_DL_LOC}/${OPM_FILENAME}
opm_exec_loc=${OPM_DL_LOC}/opm

curl -L ${opm_url} -o ${opm_archive_loc} && \
tar -xzf ${opm_archive_loc} -C ${OPM_DL_LOC}
if [ $? -ne 0 ]
then
    echo "error: problem downloading opm"
    exit 1
fi

sudo install -o root -g root -m 0755 ${opm_exec_loc} ${OPM_INSTALL_LOC}
