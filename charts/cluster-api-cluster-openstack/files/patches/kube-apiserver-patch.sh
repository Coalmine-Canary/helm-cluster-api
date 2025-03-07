#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -x

cpus="$(grep -c ^processor /proc/cpuinfo)"
memory="$(awk '/MemTotal/ { printf "%d \n", $2/1024 }' /proc/meminfo)"

export API_SERVER_CPU_LIMIT=$((cpus * 1000 * 40 / 100))m
export API_SERVER_MEMORY_LIMIT=$((memory * 80 / 100))Mi

envsubst < "/tmp/kubeadm/patches/kube-apiserver+json.tpl"  > "/etc/kubernetes/patches/kube-apiserver+json.json"
