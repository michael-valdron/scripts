#!/bin/sh

ODT2TXT_CLI=${ODT2TXT_CLI:-odt2txt}
SCRIPT_LOC=$(dirname $0)

. $SCRIPT_LOC/odtutil.sh

files=($@)

parse_filepaths_with_spaces ${files[@]}

if [ ! "$(command -v ${ODT2TXT_CLI})" ]
then
    echo "command '${ODT2TXT_CLI}' not found"
    exit 1
fi

if [ $# -eq 0 ]
then
    echo 'expecting arguments, usage: odtcat.sh ODT...'
    exit 1
elif [ $# -eq 1 ]
then
    ${ODT2TXT_CLI} "${parsed_files[0]}"
else
    for ((i=0;i<${#parsed_files[@]};i++))
    do
        echo "${parsed_files[$i]}:"
        ${ODT2TXT_CLI} "${parsed_files[$i]}"
        if [ $? -ne 0 ]
        then
            break
        fi
        echo ""
    done
fi

