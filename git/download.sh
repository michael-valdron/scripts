#!/bin/sh

GIT_CMD=${GIT_CMD:-git}
GIT_BRANCH='main'

POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
    case $1 in
        -b|--branch)
            if [ -z $2 ]
            then
                echo "Expecting a branch name to be given for flag $1"
                exit 1
            else
                GIT_BRANCH="$2"
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

GIT_SRC=$1
GIT_DEST=$2

if [ -z "${GIT_DEST}" ]; then
    GIT_DEST="$(basename ${GIT_SRC})"
    if [[ "${GIT_SRC}" == *":"* ]]; then
        GIT_DEST=${GIT_DEST%.git}
    fi
fi

$GIT_CMD clone -b "${GIT_BRANCH}" $GIT_SRC $GIT_DEST && rm -rf $GIT_DEST/.git

exit $?
