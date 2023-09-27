#!/bin/bash

query_seqs=$1				#user input query file
genome_assembly=$2			#user input subject file
feature_loc=$3				#user input BED file with locations
output_file=$4				#user input name for output file
found_homologs='found_homologs.txt'        #used to store homologous matches

tblastn \
	-query $query_seqs \
	-subject $genome_assembly \
	-outfmt '6 std qlen' \
	-task tblastn-fast \
| awk '$3>30 && $4>0.9*$13' > $found_homologs		#30% match on the matched sequence and match is 90% the length of the query length
	
#echo "$(wc -l $outfile | awk '{print $1}') matches."

while read -r i;
	do
		#these store start,end, and gene name in BED
		loc_start=$(echo "$i" | awk '{print $2}')
		loc_end=$(echo "$i" | awk '{print $3}')
		name=$(echo "$i" | awk '{print $4}')

		while read -r j;
			do	

				#stores our "homologous matches"
				homologous_start=$(echo "$j" | awk '{print $9}')
				homologous_end=$(echo "$j" | awk '{print $10}')

				#the homologous sequence must be entirely in the seqeuence for the gene
				if [[ "$homologous_start" -ge "$loc_start" && "$homologous_end" -le "$loc_end" ]];
					then
						found_name=$name
						echo "$found_name" >> "$output_file"
						break			#no need to go through rest of file if match found

				elif [[ "$homologous_start" -gt "$loc_end" ]]; then break			#since bed file is in numerical order, if homologous start is greater than end of gene loc, we wont find in file
				fi
		done < "$found_homologs";
	done < "$feature_loc"
sort "$output_file" | uniq > 'temp_file.txt'
mv 'temp_file.txt' "$output_file"
rm $found_homologs
echo "$(wc -l $output_file | awk '{print $1}') genes were found to match in $3"
