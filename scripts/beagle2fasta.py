#!/usr/bin/python3
import argparse
from collections import OrderedDict

#Read in config file for the run
parser = argparse.ArgumentParser()
parser.add_argument('--input_beagle_file', '-i', help = 'uncompressed beagle file.')
parser.add_argument('--output_fasta_file', '-o', help = 'fasta file name.')
args = parser.parse_args()

haplotypes = OrderedDict()
individuals_list = []
allele_codes = OrderedDict([("0","A"), ("1","C"), ("2","G"), ("3","T")])

with open(args.input_beagle_file, 'r') as i:
	linenum = 0
	for raw_line in i:
		line_as_list = raw_line.rstrip().split("\t")
		if linenum == 0:
			for index, individual in enumerate(line_as_list):
				if index % 3 == 1 and index / 3 > 1:
					haplo_key = int(((index - 1) / 3) - 1)
					haplotypes[haplo_key] = []
					individuals_list.append(individual)
		elif linenum > 0:
			major_allele = allele_codes[line_as_list[1]]
			minor_allele = allele_codes[line_as_list[2]]
			iterator = 1
			while iterator < (len(line_as_list) / 3):
				p_maj = line_as_list[iterator * 3]
				p_het = line_as_list[iterator * 3 + 1]
				p_min = line_as_list[iterator * 3 + 2]
				if max(p_maj, p_het, p_min) == p_maj:
					haplotypes[iterator - 1].append(major_allele)
				elif max(p_maj, p_het, p_min) == p_het:
					haplotypes[iterator - 1].append("N")
				elif max(p_maj, p_het, p_min) == p_min:
					haplotypes[iterator - 1].append(minor_allele)
				else:
					haplotypes[iterator - 1].append("N")
				iterator += 1
		linenum += 1
	print(individuals_list)

with open(args.output_fasta_file, 'w') as o:
	for ind_index, alleles in haplotypes.items():
		o.write(">" + individuals_list[ind_index] + "\n" + "".join(alleles) + "\n")