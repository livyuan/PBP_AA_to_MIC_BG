#!/bin/bash -l

train_file="/scicomp/home/yqh8/PBP_MIC/db/PBP_2528_14-MIC-AAtable.csv"
cwd="/scicomp/groups/OID/NCIRD/DBD/RDB/Strep_Lab/External/share/PBP_AA_to_MIC/newDB/"

scr1="/scicomp/groups/OID/NCIRD/DBD/RDB/Strep_Lab/External/share/PBP_AA_to_MIC/scripts/Build_RF_EN_Models.R"
Rscript $scr1 $train_file $cwd

scr1="/scicomp/groups/OID/NCIRD/DBD/RDB/Strep_Lab/External/share/PBP_AA_to_MIC/scripts/Build_MM_Model.R"
Rscript $scr1 $train_file $cwd
