import sys      #remmeber sys argv[0] is going ot be the name of script

with open(sys.argv[1]) as file:
    lines = file.readlines()

seq1 = lines[1]             #DNA sequence 1
seq2 = lines[3]             #DNA sequence 2
matches = ""

for nuc1, nuc2 in zip(seq1,seq2):

    #had to add \n because was matching endline characters
    if nuc1 == nuc2 and nuc1 != ' ' and nuc1 != '\n':
        matches +='|'
    else:
        matches += ' '
print(seq1[:-1])            #all except last cahracter which is endline
print(matches)
print(seq2[:-1])


