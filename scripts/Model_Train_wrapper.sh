#!/bin/bash -l

train_file="../data/TableS3_Dataset1_PBP_AAtable.csv"
cwd="../data"

scr1="./Build_RF_EN_Models.R"
Rscript $scr1 $train_file $cwd

scr1="../Build_MM_Model.R"
Rscript $scr1 $train_file $cwd
