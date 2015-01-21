#!/bin/sh
#
# Filename: matlab.sh
#
# ./matlab.sh "simplesleep(10,2,'output.txt')"
#

# run matlab in text mode
nohup matlab -nodisplay -nosplash -r "$*"
