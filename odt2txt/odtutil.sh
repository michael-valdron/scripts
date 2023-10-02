#!/bin/sh

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
