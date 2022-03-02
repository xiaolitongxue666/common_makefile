#!/bin/sh

clear

make clean

#Default
#Build a exe
make all
ls ./objs

#Build a static lib
make clean
make static_lib
ls ./objs
