#!/bin/bash

set -x

clear

#Build a share lib and run with it
echo "Building a share lib and run it."
make clean
make share_lib
ls ./objs

BUILD_DIR=$PWD
B_FUNCTION_DIR=$BUILD_DIR/B_function
C_FUNCTION_DIR=$BUILD_DIR/C_function
echo $BUILD_DIR
echo $B_FUNCTION_DIR
echo $C_FUNCTION_DIR
gcc lib_api_or_main.c A_function.c -o ./objs/ExecutableFileWithShareLib -I$BUILD_DIR -I$B_FUNCTION_DIR -I$C_FUNCTION_DIR -L$BUILD_DIR/objs $BUILD_DIR/objs/ShareLib.so
./objs/ExecutableFileWithShareLib