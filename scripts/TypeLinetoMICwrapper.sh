#!/bin/bash
x0="$1""/Spn_Typing_Output/" 
x1="0"
if [ -d "$1""/Spn_Typing_Output/" ]; then
x2="$x0""$(ls "$1""/Spn_Typing_Output/" | grep "TABLE_Spn" | grep "Results.txt" | awk 'NR==1')"
if [ -s "$x2" ]; then
x1="1"
fi
fi

if [ "$x1" == "1" ]; then
  AAseqDir=$1
  echo "Data folder is $AAseqDir"
else
  echo "usage bash ./TYPELINEtoMIC data_dir"
  echo ""
  echo "data_dir is the user provided output directory ( -o ) when you run StrepLab-JanOw_Spn-wrapr.sh" 
  echo "data_dir must contain a non-empty file with such name as TABLE_Spn*Results.txt in the sub dir /Spn_Typing_Output/" 
  echo ""
  echo "See README.txt for details"
  echo "Program not run"  
  exit 1
fi

#

x3="$x0""/PBPtoMIC"
rm -rf $x3
mkdir -p $x3
cd $x3
awk '{print $1}' $x2 | awk 'NR>1' > SampleID1.txt

rm -f Sample_PBP1A_AA.faa Sample_PBP2B_AA.faa Sample_PBP2X_AA.faa 
for j1 in $(cat SampleID1.txt)
do
  echo "Extracting PBP TPD AA seqs for $j1"
  f1="$x0""/""$j1""/Final-Frag_1A-S2_prot.faa"
  if [ -s $f1 ]; then
  echo ">""$j1" >>Sample_PBP1A_AA.faa
  awk 'NR>1' $f1 >>Sample_PBP1A_AA.faa
  fi

  f1="$x0""/""$j1""/Final-Frag_2B-S2_prot.faa"
  if [ -s $f1 ]; then
  echo ">""$j1" >>Sample_PBP2B_AA.faa
  awk 'NR>1' $f1 >>Sample_PBP2B_AA.faa
  fi

  f1="$x0""/""$j1""/Final-Frag_2X-S2_prot.faa"
  if [ -s $f1 ]; then
  echo ">""$j1" >>Sample_PBP2X_AA.faa 
  awk 'NR>1' $f1 >>Sample_PBP2X_AA.faa
  fi 
done

#
scr1="./AAtoMICwrapper.sh"
bash $scr1 $x3

cd $x3
rm -f temp*
sed -e 's/"//g' -e 's/,/\t/g' Sample_PBPtype_MIC2_Prediction.csv | grep -vw "TIGR4-AE005672.3" > temp1.txt
cat temp1.txt | awk -F"\t" '{ if ($2 != "new" ) {print $1"\t"$2"\t"$8"\t"$9"\t"$10"\t"$11"\t"$12"\t"$13} else \
	{print $1"\t"$2"\t"$20"\t"$21"\t"$22"\t"$23"\t"$24"\t"$25}  }' > temp2.txt
sed -e 's/_MIC_MM/w/g' temp2.txt > temp3.txt

comm -23 <(sort -k1,1 SampleID1.txt) <(awk '{print $1}' temp3.txt | sort -k1,1) |
	awk '{print $1"\t""incomplete""\t-""\t-""\t-""\t-""\t-""\t-"}' > temp4.txt
cat temp4.txt >> temp3.txt

awk 'NR>1' temp3.txt > temp3.1.txt; mv temp3.1.txt temp3.txt 
f002="./MIC_Ranges.txt"
f003=$(cat $f002 | sed 's/ /,/g')

n1=3
for j2 in $f003
do
  echo $j2
  f004=$(echo "$j2" | awk -F"," '{print $1}')
  f005=$(echo "$j2" | awk -F"," '{print $2}')
  f006=$(echo "$j2" | awk -F"," '{print $3}')
  
  cat temp3.txt | awk '{y=$x; sy="="; if ($2=="incomplete") {sy= "-"; y="-"} else \
   {if (y<=y1) {sy= "<="; y=y1}; if (y>y2) {sy=">"; y=y2}}; $x=sy"@&@"y; print $0 }' \
      x=$n1 y1=$f005 y2=$f006 f4=$f004 > temp3.1.txt; mv temp3.1.txt temp3.txt
  n1=$((n1+1))
done

sed 's/@&@/ /g' temp3.txt > temp3.1.txt; mv temp3.1.txt temp3.txt
cat $x2 | awk -F"\t" '{ if ($10 !="No_Serotype") {print $1" "$11" "$12" "$13} else {print $1" "$12" "$13" "$14} }' > temp6.txt

echo "Sample PT wPENSIGN wPEN wAMOSIGN wAMO wMERSIGN wMER wTAXSIGN wTAX wCFTSIGN wCFT wCFXSIGN wCFX" >temp7.txt
join -1 1 -2 1 <(cat temp6.txt | sort) <(cat temp3.txt | sort) >> temp7.txt
cat temp7.txt > TABLE_Spn_BLACTAM_MICs_Results.txt
cat temp7.txt | awk '{y=$2; $2=y; print $0}' | sed 's/ /,/g' > "$x0""/TABLE_Spn_BLACTAM_MICs_Results.csv"

rm temp*


echo ""
echo "BLACTAM MICs results file saved at:"
echo "$x0""/TABLE_Spn_BLACTAM_MICs_Results.csv"

echo ""
echo "Program run completed"

