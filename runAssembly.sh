#!/bin/bash

#Runs through an assembly pipeline from a list of files in a specefied directory.  This assembly pipeline #uses trimmomatic, Khmer, and IDBA.  Credit for each of those programs goes to their respective authors.

readarray seqfiles -t < filenames.txt

DIR=1 
COUNTER=1
TOTAL=96
DES=/media/sf_Assembly/Followups
DEST="/media/sf_Assembly/Followups""/$DIR"
Y=0
Z=1

while [ $COUNTER -le $TOTAL ]
do
  DEST="/media/sf_Assembly/Followups""/$DIR"; mkdir "$DES""/$DIR"; cd "/media/sf_Assembly/Followups""/$DIR"; cat "/media/sf_Assembly/20161123_DNASeq_PE/""$(echo -e "${seqfiles[$Y]}" | tr -d '\040\011\012\015')" "/media/sf_Assembly/20161123_DNASeq_PE/""$(echo -e "${seqfiles[$Y+2]}" | tr -d '\040\011\012\015')" > Forward.fastq.gz; echo $Y $Y+2 >> forwardlog.txt; echo $Z $Z+2 >> reverselog.txt; cat "/media/sf_Assembly/20161123_DNASeq_PE/""$(echo -e "${seqfiles[$Z]}" | tr -d '\040\011\012\015')" "/media/sf_Assembly/20161123_DNASeq_PE/""$(echo -e "${seqfiles[$Z+2]}" | tr -d '\040\011\012\015')" > Reverse.fastq.gz; FILE="$DEST""/Forward.fastq.gz" ; FILE2="$DEST""/Reverse.fastq.gz"; java -jar /usr/share/java/trimmomatic-0.32.jar PE -phred33 $FILE $FILE2 "$DEST""/trim.f.pe.fq.gz" "$DEST""/trim.f.se.fq.gz" "$DEST""/trim.r.pe.fq.gz" "$DEST""/trim.r.se.fq.gz" ILLUMINACLIP:/media/sf_Linuxshared/illuminaClipping.fa:2:30:6 HEADCROP:14 CROP:230  LEADING:10 TRAILING:10 SLIDINGWINDOW:3:15 MINLEN:30; echo $FILE >> trimlog.txt; echo $FILE2 >> trimlog.txt; echo "fin" >>  trimlog.txt; echo $DIR >> DIR.txt; runKhmer.sh; mkdir idba; gunzip -k PE_combined.f.pe.fq.gz; cd //; cd /home/manager/idba-1.1.3; bin/fq2fa --paired --filter /media/sf_Assembly/Followups/$DIR/PE_combined.f.pe.fq /media/sf_Assembly/Followups/$DIR/idba/read.fa; bin/idba_ud --pre_correction --min_contig 200 -r /media/sf_Assembly/Followups/$DIR/idba/read.fa -o /media/sf_Assembly/Followups/$DIR/idba; cd /home/manager/Desktop; echo $DIR >> log.txt;
  #echo $COUNTER
  #echo $TOTAL
  Y=$(( $Y + 4 ))
  Z=$(( $Z +4 ))
  COUNTER=$(( $COUNTER + 1 ))
  DIR=$(( $DIR + 1 ))
done
