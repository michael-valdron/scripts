#!/bin/sh

OC_CLI=${OC_CLI:-oc}

if [ -z $(which ${OC_CLI} 2> /dev/null) ] || \
[ ! -f $(which ${OC_CLI} 2> /dev/null) ]; then
    echo "${OC_CLI} does not exist"
    exit 1
fi

POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
    case $1 in
        -c|--change)
            if [ -z $2 ]
            then
                echo "Expecting a project name to be given for flag $1"
                exit 1
            else
                CHANGE_PROJ="$2"
                shift # past argument
                shift # past value
            fi
            ;;
        -*|--*)
            echo "Unknown option $1"
            exit 1
            ;;
        *)
            POSITIONAL_ARGS+=("$1") # save positional arg
            shift # past argument
            ;;
    esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

if [ -z ${CHANGE_PROJ} ]
then
    ${OC_CLI} project
else
    ${OC_CLI} project ${CHANGE_PROJ}
fi
