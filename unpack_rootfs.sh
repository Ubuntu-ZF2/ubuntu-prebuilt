#!/bin/bash
#
# Copyright 2014 Canonical Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
if [ -n $2 -a -f $2 ]; then
    source $2
fi
if [[ ! -z $UBUNTU_ROOTFS_PACKAGES ]]; then
    rm -rf $1/* >/dev/null
    rm -f $1.content >/dev/null
    mkdir -p $1 >/dev/null
    for package in $UBUNTU_ROOTFS_PACKAGES
    do
        if [ -f $package ]; then
            echo "Unpacking $package"
            tar --numeric-owner --strip-components=1 --exclude=system/dev/* -xvvf $package --directory $1 --wildcards system/ >> $1.content
        fi
    done

    # echo unpack device blobs if needed
    if [ -n "$3" ]; then
        rm -rf $3
        mkdir -p $3
        for package in $UBUNTU_ROOTFS_PACKAGES
        do
            if [ -f $package ]; then
                echo "Unpacking blobs from $package"
                tar --strip-components=1 --exclude=system/* -xvvf $package --directory $3
            fi
        done
    fi
fi

