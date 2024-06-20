#!/bin/sh

OPENSHIFT_INSTALL_CLI=${OPENSHIFT_INSTALL_CLI:-openshift-install}
OPENSHIFT_INSTALL_DIR=${OPENSHIFT_INSTALL_DIR:-'~/.openshift-install'}
YQ_CLI=${YQ_CLI:-yq}

if [ ! "$(command -v ${OPENSHIFT_INSTALL_CLI})" ]; then
    echo "openshift-install command \"${OPENSHIFT_INSTALL_CLI}\" does not exists on system"
    exit 1
elif [ $# -ne 2 ]; then
    echo "error: expecting two arguments: sh create.sh <cmd: cluster|install-config> <cluster_name>"
    exit 1
fi

openshift_install_create_cli="${OPENSHIFT_INSTALL_CLI} create"

case "${1}" in
    cluster)
        if [ -f "${2}.yaml" ]
        then
            cp ${OPENSHIFT_INSTALL_DIR}/${2}.yaml ${OPENSHIFT_INSTALL_DIR}/${2}/install-config.yaml
        elif [ -f "${2}.yml" ]
        then
            cp ${OPENSHIFT_INSTALL_DIR}/${2}.yml ${OPENSHIFT_INSTALL_DIR}/${2}/install-config.yaml
        else
            echo "error: unknown cluster profile '${2}'"
            exit 1
        fi

        ${openshift_install_create_cli} cluster --dir ${OPENSHIFT_INSTALL_DIR}/${2}
    ;;
    install-config)
        if [ ! "$(command -v ${YQ_CLI})" ]; then
            echo "yq command \"${YQ_CLI}\" does not exists on system"
            echo "note: yq is needed to create a cluster install-config from a base install config"
            exit 1
        fi  

        base_config_path=${OPENSHIFT_INSTALL_DIR}/${AWS_PROFILE:-'default'}/base.yaml
        if [ ! -f ${base_config_path} ]
        then
            ${openshift_install_create_cli} install-config --dir ${OPENSHIFT_INSTALL_DIR} && \
                mkdir -p $(dirname ${base_config_path}) && \
                mv ${OPENSHIFT_INSTALL_DIR}/install-config.yaml ${base_config_path}
        fi

        if [ -f ${base_config_path} ]
        then
            cp ${base_config_path} ${OPENSHIFT_INSTALL_DIR}/${2}.yaml
        elif [ ! -z "${AWS_PROFILE}" ]
        then
            echo "error: no base install-config was created for AWS profile '${AWS_PROFILE}'"
            exit 1
        else
            echo "error: no base install-config was created"
            exit 1
        fi

        ${YQ_CLI} -i ".metadata.name = \"${2}\"" ${OPENSHIFT_INSTALL_DIR}/${2}.yaml
    ;;
    *)
        echo "error: not a 'openshift-install create' command, expecting 'cluster' or 'install-config'"
        exit 1
    ;;
esac
