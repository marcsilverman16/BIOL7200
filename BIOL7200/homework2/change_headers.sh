#!/bin/bash

filename="$1"
delimiter=">"   #character searching for

#gets rid of everything at and after the '.'
additional_header="${filename%.*}"

#s stands for substitute, g stands for global, meaning all occurences of
sed "s/$delimiter/$delimiter$additional_header /g" "$filename" > "$2"
