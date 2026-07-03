#!/bin/bash

REBASE_ARGS=()

DO_PUSH=0
WORKING_DIRECTORY=''

GIT_DEST_REMOTE=${GIT_DEST_REMOTE:-'origin'}
GIT_CMD="$(which git 2> /dev/null)"

# parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --push)
            DO_PUSH=1
            shift 1
        ;;
        --working-directory|-w)
            WORKING_DIRECTORY=$2
            if [ -z $WORKING_DIRECTORY ] && [ ! -d $WORKING_DIRECTORY ]; then
                echo "'${WORKING_DIRECTORY}' invalid directory, expected --working-directory or -w to be followed by a valid directory path" >&2; exit 1
            fi
            shift 2
        ;;
        --yadm)
            GIT_CMD="$(which yadm 2> /dev/null)"
            shift 1
        ;;
        --continue)
            ${GIT_CMD} add -A
            REBASE_ARGS+=("$1")
            shift 1
        ;;
        *)
            REBASE_ARGS+=("$1")
            shift 1
        ;;
    esac
done

set -- "${REBASE_ARGS[@]}" # restore parameters for git rebase

if [ -n "${WORKING_DIRECTORY}" ]; then
    GIT_CMD="${GIT_CMD} -C ${WORKING_DIRECTORY}"
fi

GIT_CURR_BRANCH="$($GIT_CMD rev-parse --abbrev-ref HEAD 2> /dev/null)"
GIT_BRANCH=${GIT_CURR_BRANCH}
GIT_REBASE_CMD="${GIT_CMD} rebase $@"
EXIT_STATUS=0

# fetch remote updates
${GIT_CMD} fetch --all

if [ $DO_PUSH -eq 1 ]; then
    ${GIT_REBASE_CMD} && GIT_BRANCH="$($GIT_CMD rev-parse --abbrev-ref HEAD 2> /dev/null)" && ${GIT_CMD} push -f ${GIT_DEST_REMOTE} ${GIT_BRANCH} || EXIT_STATUS=1
else
    ${GIT_REBASE_CMD} && GIT_BRANCH="$($GIT_CMD rev-parse --abbrev-ref HEAD 2> /dev/null)" || EXIT_STATUS=1
fi

if [[ "${GIT_CURR_BRANCH}" != "${GIT_BRANCH}" ]]; then
    GIT_DIR="$($GIT_CMD rev-parse --git-dir 2> /dev/null)"
    if [ ! -d "${GIT_DIR}/rebase-merge" ] && [ ! -d "${GIT_DIR}/rebase-apply" ]; then
        ${GIT_CMD} checkout ${GIT_CURR_BRANCH}
    fi
fi

exit ${EXIT_STATUS}
