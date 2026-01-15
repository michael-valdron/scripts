#!/bin/bash

POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--nopush)
            do_push=false
            shift
            ;;
        --ssl-no-verify)
            SSL_VERIFY=false
            shift
            ;;
        -*|--*)
            echo "Unknown option $1" >&2
            exit 1
            ;;
        *)
            POSITIONAL_ARGS+=("$1") # save positional arg
            shift # past argument
            ;;
    esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

package_list_alias=$1
git_url=$2
branch_name=${package_list_alias}_$(head -c 32 /dev/urandom | sha256sum | cut -d' ' -f1)
output_dir=/tmp/$branch_name
base_dir=$(dirname $0)
do_push=${do_push:-true}
ssl_verify=${SSL_VERIFY:-true}

if [[ $git_url != http://* && $git_url != https://* ]]; then
    echo "Unsupported URL scheme" >&2
    exit 1
fi

echo "Cloning '$git_url'..."
git -c http.sslVerify=${ssl_verify} clone $git_url $output_dir || exit 1

echo "Checking out dumping branch '$branch_name'..."
cd $output_dir && git checkout -b $branch_name && cd - || exit 1

echo "Dumping package list..."
bash $base_dir/dump.sh ${package_list_alias} ${output_dir} || exit 1

echo "Committing changes..."
cd $output_dir && git add -A && git commit -m "dumping '$package_list_alias' package list" && cd - || exit 1

if [[ "$do_push" == "true" ]]; then
    git_token=${GIT_TOKEN:-''}
    if [ ! -z "${git_token}" ]; then
        git_url=${git_url//https\:\/\//https\:\/\/${git_token}\@}
        git_url=${git_url//http\:\/\//http\:\/\/${git_token}\@}
        cd $output_dir && git remote set-url origin ${git_url} && cd - || exit 1
    fi
    cd $output_dir && git -c http.sslVerify=${ssl_verify} push origin $branch_name && cd - || exit 1
    rm -rf $output_dir || exit 1
else
    echo "Skipping push, changes are located under ${output_dir}"
fi
