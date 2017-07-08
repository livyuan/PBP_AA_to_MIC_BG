#!/bin/bash -l

source /etc/profile.d/modules.sh

dir1="./"
file1="../data/PBP_2528_14-MIC-AAtable_Rand_MIC.csv"
file1_1="../data/uniquePT.csv"

j1=$SGE_TASK_ID

j2=$((j1+1))
ID1=$(awk 'NR==j2' j2=$j2 $file1_1 | awk -F"," '{print $1}' | sed 's/\"//g')

dir2="$dir1"$ID1"/"
mkdir -p $dir2
cd $dir2

file2=$dir2"train_file-"$j1".csv"
grep -vw "$ID1" $file1 > $file2

script1="./Build_RF_EN_Models.R"
Rscript $script1 $file2 $dir2

script1="./Build_MM_Model.R"
Rscript $script1 $file2 $dir2

file3="Sample_PBP_AA_table.csv"
awk 'NR ==1'  $file1 > $file3
grep -w "$ID1" $file1 | awk 'NR==1'>> $file3

script1="./AAtable_To_MIC_MM_RF_EN.R"
Rscript $script1 $dir2

