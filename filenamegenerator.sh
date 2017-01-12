#!/bin/bash

#This program generates a .txt file with the filenames ina  specefic directory
#replace //media/sf_Assembly/20161123_DNAseq_PE to desired directory

ls //media/sf_Assembly/20161123_DNAseq_PE > filenames.txt
readarray seqfiles -t < filenames.txt

