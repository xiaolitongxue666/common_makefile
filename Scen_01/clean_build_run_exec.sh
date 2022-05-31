#!/bin/bash

set -x

clear

#Build a exe and run it
@echo "Building a exe and run it."
make clean
make executable_file
ls ./objs
./objs/ExecutableFile