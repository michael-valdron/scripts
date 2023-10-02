#!/bin/sh

ODT2TXT_CLI=${ODT2TXT_CLI:-odt2txt}
SCRIPT_LOC=$(dirname $0)

args=($@)
search_str=$(echo ${args[0]} | awk '{print tolower($0)}')
files=(${args[@]:1})

. $SCRIPT_LOC/odtutil.sh

parse_filepaths_with_spaces ${files[@]}

if [ ! "$(command -v ${ODT2TXT_CLI})" ]
then
    echo "command '${ODT2TXT_CLI}' not found"
    exit 1
fi

if [ $# -lt 2 ]
then
    echo 'expecting two arguments, usage: odtsearch.sh <search_str> ODT...'
    exit 1
else
    for ((i=0;i<${#parsed_files[@]};i++))
    do
        result=$(${ODT2TXT_CLI} "${parsed_files[$i]}" | awk '{print tolower($0)}')
        parsed_file_lower=$(echo ${parsed_files[$i]} | awk '{print tolower($0)}')
        if [[ ${parsed_file_lower} =~ .*${search_str}.* ]] || [[ ${result} =~ .*${search_str}.* ]]
        then
            echo "${parsed_files[$i]}"
        fi
    done
fi
