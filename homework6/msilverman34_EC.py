#!/usr/bin/env python

import pandas as pd
import sys

#for schema
column_names = ['qseqid', 'sseqid', 'pident', 'length', 'mismatch', 'gapopen', 'qstart', 'qend', 'sstart', 'send', 'evalue', 'bitscore', 'qlen']

#creates dataframe with the column names
blast_df = pd.read_csv(sys.argv[1], sep='\t', header=None)
blast_df.columns = column_names

homologous_df = blast_df.query('pident > 30 & (length > 0.9 * qlen)')    #have matches

bed_columns = ['seqID', 'start', 'stop', 'name', 'score', 'dir']
bed_df = pd.read_csv(sys.argv[2], sep="\t", header=None, names=bed_columns)

matches = set()

for index, row in homologous_df.iterrows():

    for i, r in bed_df.iterrows():

        if row['sstart'] >= r['start'] and row['send'] <= r['stop']:
            matches.add(r['name'])


with open(sys.argv[3], 'w') as f:
  for m in matches:
    f.write(f"{m}\n")

print(len(matches), "genes were found to match the HK domaine with Vibrio_cholerae_N16961 based on our query")
