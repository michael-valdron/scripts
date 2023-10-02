#!/bin/sh

PDF2TXT_CLI=${PDF2TXT_CLI:-pdf2txt}

args=($@)
search_str=$(echo ${args[0]} | awk '{print tolower($0)}')
files=(${args[@]:1})

parsed_files=()

function parse_filepaths_with_spaces() {
    files=($@)
    
    parsed_files+=(${files[0]})

    j=0
    for ((i=1;i<${#files[@]};i++))
    do
        if [[ "${files[$i]}" =~ ^/.* ]]
        then
            parsed_files+=(${files[$i]})
            ((j++))
        else
            parsed_files[$j]="${parsed_files[$j]} ${files[$i]}"
        fi
    done
}

parse_filepaths_with_spaces ${files[@]}

if [ ! "$(command -v ${PDF2TXT_CLI})" ]
then
    echo "command '${PDF2TXT_CLI}' not found"
    exit 1
fi

if [ $# -lt 2 ]
then
    echo 'expecting two arguments, usage: pdfsearch.sh <search_str> PDF...'
    exit 1
else
    for ((i=0;i<${#parsed_files[@]};i++))
    do
        result=$(${PDF2TXT_CLI} "${parsed_files[$i]}" | awk '{print tolower($0)}')
        parsed_file_lower=$(echo ${parsed_files[$i]} | awk '{print tolower($0)}')
        if [[ ${parsed_file_lower} =~ .*${search_str}.* ]] || [[ ${result} =~ .*${search_str}.* ]]
        then
            echo "${parsed_files[$i]}"
        fi
    done
fi
