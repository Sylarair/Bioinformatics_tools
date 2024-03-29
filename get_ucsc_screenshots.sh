#!/bin/bash

# Author: Qin Wang
# Usage: ucsc_screenshots.sh hublink bed_file Your_outpath
# Example: ucsc_screenshots.sh https://***/hub.txt narrowPeak.bed /home/***/***
# hublink is what you put into the UCSC browser(the hub.txt contains all the tracks you have loaded)
# hublink example: https://users.wenglab.org/***/***/***/hub.txt

hublink=$1
infile=$2
outpath=$3
# db is the genome
db=$4

### your bed file has a 4 columns at least, like: chr1 1000000 1010000 peak-1
ranges=( $(cut -f1-4 ${infile} | awk '{print $1":"$2"-"$3"."$4}') )
#echo $ranges
for i in "${ranges[@]}"; do
    # position="chr1:1000000-1010000"
    position=$(echo $i | cut -d. -f1)
    # position=$(echo $i)
    #echo ${i}
    ### using the 4th column to name pdf files
    outpdf=${outpath}"/"$(echo $i | cut -d. -f2).pdf
    #https://genome.ucsc.edu/cgi-bin/hgTracks?db=mm10&position=chr8:126820533-126833569&hubClear=https://users.wenglab.org/***/***/***/hub.txt

    pdf_page="http://genome-asia.ucsc.edu/cgi-bin/hgTracks?db="${db}"&lastVirtModeType=default&lastVirtModeExtraState=&virtModeType=default&virtMode=0&nonVirtPosition=&position="${position}"&hgsid=729643552_UNeIe63ftsk5uNAkqnymWTBLwvax&hgt.psOutput=on" #downloading screenshots

    # pdf_page="https://genome-asia.ucsc.edu/cgi-bin/hgTracks?db=$db&position=$position&hubClear=$hublink&hgt.psOutput=on" # sharing with others
    
    pdf_url=$(curl -s "$pdf_page" | grep "the current browser graphic in PDF" | grep -E -o "\".+\"" | tr -d "\"" | sed 's/../https:\/\/genome-asia.ucsc.edu/')
    echo ${pdf_url}
    echo "Saving $outpdf from $pdf_url"
    curl -s -o ${outpdf} "$pdf_url"
done
