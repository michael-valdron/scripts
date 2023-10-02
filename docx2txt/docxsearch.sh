#!/bin/sh

DOCX2TXT_CLI=${DOCX2TXT_CLI:-docx2txt}
SCRIPT_LOC=$(dirname $0)

args=($@)
search_str=$(echo ${args[0]} | awk '{print tolower($0)}')
files=(${args[@]:1})

. $SCRIPT_LOC/docxutil.sh

parse_filepaths_with_spaces ${files[@]}

if [ ! "$(command -v ${DOCX2TXT_CLI})" ]
then
    echo "command '${DOCX2TXT_CLI}' not found"
    exit 1
fi

if [ $# -lt 2 ]
then
    echo 'expecting two arguments, usage: docxsearch.sh <search_str> DOCX...'
    exit 1    
else
    for ((i=0;i<${#parsed_files[@]};i++))
    do
        result=$(${DOCX2TXT_CLI} "${parsed_files[$i]}" | awk '{print tolower($0)}')
        parsed_file_lower=$(echo ${parsed_files[$i]} | awk '{print tolower($0)}')
        if [[ ${parsed_file_lower} =~ .*${search_str}.* ]] || [[ ${result} =~ .*${search_str}.* ]]
        then
            echo "${parsed_files[$i]}"
        fi
    done
fi
