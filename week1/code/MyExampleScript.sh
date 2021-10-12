#!/bin/bash
# Author: Lizzie Bru eab21@imperial.ac.uk
# Script: MyExampleScript.sh
# Desc: demonstrating how values can be assigned using explicit declaration
# Arguments: none
# Date: Oct 2021

msg1="Hello"
msg2=$USER
echo "$msg1 $msg2"
echo "Hello $USER"
echo