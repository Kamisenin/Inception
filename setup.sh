#!/bin/sh

if [ ! -d "${DATA_PATH}/data/db" ]; then
    mkdir -p "${DATA_PATH}/data/db"
fi


if [ ! -d "${DATA_PATH}/data/wordpress" ]; then
    mkdir -p "${DATA_PATH}/data/wordpress"
fi