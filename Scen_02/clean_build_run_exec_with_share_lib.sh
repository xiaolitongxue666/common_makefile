#!/bin/bash

set -x

clear

#Build a share lib and run with it
echo "Building a share lib and run it."
make clean
make share_lib
ls ./build

BUILD_DIR=$PWD/src
B_FUNCTION_DIR=$BUILD_DIR/B_function
C_FUNCTION_DIR=$B_FUNCTION_DIR/C_function
echo $BUILD_DIR
echo $B_FUNCTION_DIR
echo $C_FUNCTION_DIR
gcc $BUILD_DIR/main.c $BUILD_DIR/A_function.c -o ./build/ExecutableFileWithShareLib -I$BUILD_DIR -I$B_FUNCTION_DIR -I$C_FUNCTION_DIR -L./build ./build/ShareLib.so
./build/ExecutableFileWithShareLib