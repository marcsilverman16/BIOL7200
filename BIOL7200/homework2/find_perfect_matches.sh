#!/bin/bash

#variables
query_file=$1
subject_file=$2
output_file=$3

blastn -query $query_file -subject $subject_file -task blastn-short -outfmt 6  | awk '$3 == 100 && $4 == 28' > $output_file
echo "There are $(wc -l $output_file | awk '{print $1}') perfect matches."
