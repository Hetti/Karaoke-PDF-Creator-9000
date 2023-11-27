#!/bin/bash
# Random PDF Karaoke Creator, inspired bei Kirils

slidedir="./in"
outputdir="./output"
name=`date +%s`-$RANDOM.pdf
outputfile=$outputdir/$name

mkdir -p $outputdir

echo "[+] Get title slide"
random_deck=`ls -1 $slidedir/*.pdf | sort -R | head -1`
echo "Random Slide Deck: $random_deck"
pdftk "$random_deck" cat 1 output "$outputfile"_title

echo "[+] Get intro slide"
random_deck=`ls -1 $slidedir/*.pdf | sort -R | head -1`
echo "Random Slide Deck: $random_deck"
pdftk A="$outputfile"_title B="$random_deck" cat A B2 output "$outputfile"_0
rm "$outputfile"_title

# Loop 7 times and get everytime a random slide from 3 - MAX-1
for i in {0..6}
do
  #echo $i
  random_deck=`ls -1 $slidedir/*.pdf | sort -R | head -1`
  # Source: https://stackoverflow.com/a/14736593
  pagecount=`pdftk "$random_deck" dump_data | grep NumberOfPages | awk '{print $2}'`
  # echo $pagecount

  max_slide=$(($pagecount-1))
  chosen_rand_page=`seq 3 $max_slide | sort -R | head -n 1`
  echo "Random Page chosen: $chosen_rand_page"
  pdftk A="$outputfile"_"$i" B="$random_deck" cat A B$chosen_rand_page output "$outputfile"_$(($i+1))
  rm $outputfile"_"$i
done

echo "[+] Get outro slide"
  random_deck=`ls -1 $slidedir/*.pdf | sort -R | head -1`
  # Source: https://stackoverflow.com/a/14736593
  pagecount=`pdftk "$random_deck" dump_data | grep NumberOfPages | awk '{print $2}'`
  echo $pagecount
  pdftk A="$outputfile"_7 B="$random_deck" cat A B$pagecount output $outputfile
  rm "$outputfile"_7

echo "[+] Your Karaoke PDF was created - Good Luck!"
#pdfpc $outputfile