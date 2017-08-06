#!/bin/bash

IMAGE_DIR="../public/images"
if [ ! -d $IMAGE_DIR ]; then
    echo mkdir $IMAGE_DIR
    mkdir $IMAGE_DIR
fi
if [ ! -d $IMAGE_DIR/icon ]; then
    echo mkdir $IMAGE_DIR/icon
    mkdir $IMAGE_DIR/icon
fi


