#!/bin/bash

query_seqs=$1				#user input query file

genome_assembly=$2			#user input subject file
feature_loc=$3				#user input BED file with locations
output_file=$4				#user input name for output file
found_homologs='found_homologs.txt'        #used to store homologous matches

for file in $fna_files; do

	tblastn \
		-query $query_seqs \
		-subject $genome_assembly \
		-outfmt '6 std qlen' \
		-task tblastn-fast \
	| awk '$3>30 && $4>0.9*$13' > $found_homologs		#30% match on the matched sequence and match is 90% the length of the query length
		
	#echo "$(wc -l $outfile | awk '{print $1}') matches."

	#Homologous matches
	while read -r j sseqid pident length mismatch gapopen qstart qend homologous_start homologous_end evalue bitscore; 
		do

			#BED file
			while read -r i loc_start loc_end gene dot strand; 
				do	

					#the homologous sequence must be entirely in the seqeuence for the gene
					if [[ "$homologous_start" -ge "$loc_start" && "$homologous_end" -le "$loc_end" ]];
						then

							echo "$gene" >> "$output_file"
							#break			#no need to go through rest of file if match found
					#elif [[ "$loc_end" -gt "$homologous_start" ]]; then break			#since bed file is in numerical order, if homologous start is greater than end of gene loc, we wont find in file
					fi
			done < "$feature_loc";
		done < "$found_homologs"

	#uniq command only works on sorted output
	sort "$output_file" | uniq > 'temp_file.txt'
	mv 'temp_file.txt' "$output_file"
	rm $found_homologs
	echo "$(wc -l $output_file | awk '{print $1}') genes were found to match in $3"
done