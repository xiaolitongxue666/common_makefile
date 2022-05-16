#!/bin/sh

clear

make clean

#Default
#Build a exe
make executable_file
ls ./objs


#Build a static lib
make clean
make static_lib
ls ./objs
