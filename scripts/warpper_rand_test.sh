#!/bin/bash -l


dir1="/scicomp/home/yqh8/PBP_MIC/leave1out_Rand_test/"
mkdir -p dir1
cd dir1
rf -f temp*
file1="/scicomp/home/yqh8/PBP_MIC/db/PBP_2528_14-MIC-AAtable.csv"
file2="/scicomp/home/yqh8/PBP_MIC/db/PBP_2528_14-MIC-AAtable_Rand_MIC.csv"

RANDOM=1001

awk -F"," '{print $1","$2}' $file1 | awk 'NR>1'> temp1.txt
awk -F"," '{print $3}' $file1 | awk 'NR>1' | shuf > temp2.txt
awk -F"," '{print $4}' $file1 | awk 'NR>1' | shuf > temp3.txt
awk -F"," '{print $5}' $file1 | awk 'NR>1' | shuf > temp4.txt
awk -F"," '{print $6}' $file1 | awk 'NR>1' | shuf > temp5.txt
awk -F"," '{print $7}' $file1 | awk 'NR>1' | shuf > temp6.txt
awk -F"," '{print $8}' $file1 | awk 'NR>1' | shuf > temp7.txt
awk -F","  'NR>1' $file1 | awk -F"," '{ s = ""; for (i = 9; i <= NF; i++) s = s $i " "; print s }' | sed 's/ /,/g' > temp8.txt

paste temp1.txt temp2.txt temp3.txt temp4.txt temp5.txt temp6.txt temp7.txt temp8.txt -d ',' > temp9.txt 

awk 'NR==1' $file1 > $file2
cat temp9.txt >> $file2
n1=$(awk -F"," 'NR>1' $file2 | awk -F"," '{print $2}' | sort | uniq | wc -l)  #307

rm *

subdir1="/scicomp/home/yqh8/PBP_MIC/qsubfiles/"
mkdir -p $subdir1
exefile1="/scicomp/home/yqh8/PBP_MIC/scripts/step1_Rand_test.sh"

n1=307

qsub -sync y -t 1-$n1:1 -e $subdir1 -o $subdir1 $exefile1 

x1=$(cat "/scicomp/home/yqh8/PBP_MIC/leave1out_NewType/uniquePT.csv" | awk 'NR>1' \
  |  sed 's/\"//g' | awk '{print "/scicomp/home/yqh8/PBP_MIC/leave1out_Rand_test/"$1"/Sample_PBPtype_MIC2_Prediction.csv"}')

cat $x1 > temp1.txt 
f2="/scicomp/groups/OID/NCIRD/DBD/RDB/Strep_Lab/External/share/PBP_AA_to_MIC/data/Rand_test_PBPtype_MIC2_Prediction.csv"
awk 'NR==1' temp1.txt > $f2
grep -v "APT" temp1.txt >> $f2






