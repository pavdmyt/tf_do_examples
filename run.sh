#!/bin/bash

PLAN_PATH="./tf-plan"
PVT_KEY_PATH="$HOME/.ssh/id_rsa"
PUB_KEY_PATH="$HOME/.ssh/id_rsa.pub"
FINGERPRINT=$(ssh-keygen -E md5 -lf "$PUB_KEY_PATH" | awk -F " " '{ print $2 }')


function call_tf () {
    local -r args="$1"

    terraform $args \
        -var "do_token=${DO_TOKEN}" \
        -var "pub_key=${PUB_KEY_PATH}" \
        -var "pvt_key=${PVT_KEY_PATH}" \
        -var "ssh_fingerprint=${FINGERPRINT/MD5:/}" \
        -var "uname=${USER}"
}

function plan () {
    call_tf plan -out "$PLAN_PATH"
}

function apply () {
    call_tf apply -out "$PLAN_PATH"
}

function destroy () {
    call_tf destroy
}

function print_usage () {
    echo "usage: $0 ( plan | apply | destroy )"
}

function main () {
    if [ -z ${1+x} ] || [[ ${1} = *"help"* ]]; then
        print_usage
        exit 1
    fi

    if [ "$1" != "plan" ] && [ "$1" != "apply" ] && [ "$1" != "destroy" ]; then
        print_usage
        exit 1
    fi

    $1
}

main "${@}"
