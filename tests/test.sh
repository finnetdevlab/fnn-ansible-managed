#!/bin/bash

DOCKERFILE_PATH_PREFIX="images"

test()
{
    for dockerfile in $DOCKERFILE_PATH_PREFIX/$OS_FAMILY/$OS_NAME/$OS_VERSION/Dockerfile; do
        file_os_family=$(echo $dockerfile | cut -d'/' -f2)
        file_os_name=$(echo $dockerfile | cut -d'/' -f3) 
        file_os_version=$(echo $dockerfile | cut -d'/' -f4)

        printf "\n\n"
        printf "Running tests for $file_os_family $file_os_name $file_os_version"
        printf "\n---------------------------------------------------------------\n\n"

        # Suppress ruby warnings
        export RUBYOPT="-W0";

        if [ $BUILD ]
        then
            docker build -t finnetdevlab/fnn-ansible-managed:$file_os_name$file_os_version -f $dockerfile .
        fi

        OS_FAMILY="$file_os_family" \
        OS_NAME="$file_os_name" \
        OS_VERSION="$file_os_version" \
        rspec tests/spec.rb

        if [ $? -ne 0 ]
        then
            printf "\n\n"
            printf "Tests are not succeed for $file_os_family $file_os_name $file_os_version"
            printf "\n\n"
            exit 1
        fi
    done

    exit 0
}

while [[ $# -gt 0 ]]; do
key="$1"
    case $key in
        -b|--build)
            BUILD=YES
            shift
        ;;
        -f | --family)
            OS_FAMILY="$2"
            shift
            shift
        ;;
        -o | --os)
            OS_NAME="$2"
            shift
            shift
        ;;
        -v | --version)
            OS_VERSION="$2"
            shift
            shift
        ;;
        *)
            printf "Unknown argument $1"
            exit 1
        ;;
    esac
done

OS_FAMILY=${OS_FAMILY:-"*"}
OS_NAME=${OS_NAME:-"*"}
OS_VERSION=${OS_VERSION:-"*"}

test