#!/bin/sh

export MAX_SIZE=$((100 * 1000 * 1000 * 2))
export MIN_SIZE=$((7 * 1000 * 1000 * 2))
export TARGET_FILE="/tmp/target"
export INSTALL_DIR="/install"

SOURCE=/source
ROOT_DEV=/root_dev
ISO_PREFIX="jw-"
ROOT_SIZE=4000M
OPT_SIZE=1000M
LOCAL_SIZE=1000M

ROOT_DIR=/tmp/root
OPT_DIR=/tmp/opt
LOCAL_DIR=/tmp/local

