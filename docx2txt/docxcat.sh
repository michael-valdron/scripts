#!/bin/sh

DOCX2TXT_CLI=${DOCX2TXT_CLI:-docx2txt}
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

files=($@)

parse_filepaths_with_spaces ${files[@]}

if [ ! "$(command -v ${DOCX2TXT_CLI})" ]
then
    echo "command '${DOCX2TXT_CLI}' not found"
    exit 1
fi

if [ $# -eq 0 ]
then
    echo 'expecting arguments, usage: docxcat.sh DOCX...'
    exit 1
elif [ $# -eq 1 ]
then
    ${DOCX2TXT_CLI} "${parsed_files[0]}"
else
    for ((i=0;i<${#parsed_files[@]};i++))
    do
        echo "${parsed_files[$i]}:"
        ${DOCX2TXT_CLI} "${parsed_files[$i]}"
        if [ $? -ne 0 ]
        then
            break
        fi
        echo ""
    done
fi

