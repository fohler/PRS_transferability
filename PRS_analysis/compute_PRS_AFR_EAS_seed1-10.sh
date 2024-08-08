#!/bin/bash
#SBATCH --job-name=computePRS_seed1-10_lb_down
#SBATCH --time=2:00:00
#SBATCH --partition=short
#SBATCH --array=1-100
#SBATCH --mem=50G
#SBATCH --account=ag_igsb_krawitz # for bonna
#SBATCH --mail-type=ALL
#SBATCH --mail-user=fohler@uni-bonn.de

module load PLINK

if (( $SLURM_ARRAY_TASK_ID >= 1 && $SLURM_ARRAY_TASK_ID <=10)); then
        seed=1
        ind=1
elif (( $SLURM_ARRAY_TASK_ID >= 11 && $SLURM_ARRAY_TASK_ID <=20)); then
        seed=2
        ind=11
elif (( $SLURM_ARRAY_TASK_ID >= 21 && $SLURM_ARRAY_TASK_ID <=30)); then
        seed=3
        ind=21
elif (( $SLURM_ARRAY_TASK_ID >= 31 && $SLURM_ARRAY_TASK_ID <=40)); then
        seed=4
        ind=31
elif (( $SLURM_ARRAY_TASK_ID >= 41 && $SLURM_ARRAY_TASK_ID <=50)); then
        seed=5
        ind=41
elif (( $SLURM_ARRAY_TASK_ID >= 51 && $SLURM_ARRAY_TASK_ID <=60)); then
        seed=6
        ind=51
elif (( $SLURM_ARRAY_TASK_ID >= 61 && $SLURM_ARRAY_TASK_ID <=70)); then
        seed=7
        ind=61
elif (( $SLURM_ARRAY_TASK_ID >= 71 && $SLURM_ARRAY_TASK_ID <=80)); then
        seed=8
        ind=71
elif (( $SLURM_ARRAY_TASK_ID >= 81 && $SLURM_ARRAY_TASK_ID <=90)); then
        seed=9
        ind=81
elif (( $SLURM_ARRAY_TASK_ID >= 91 && $SLURM_ARRAY_TASK_ID <=100)); then
        seed=10
        ind=91
fi

tb=sim/lb_down/seed_${seed}

FILE_h05_p1=(~/PRS_transferability/${tb}/m_out_*_rec1.0e-08_s-0.001_h0.5_p1.vcf.fam)
bfile_h05_p1=${FILE_h05_p1%.fam}
BASENAMES_h05_p1=$(basename "$FILE_h05_p1" .fam)

FILE_h05_p3=(~/PRS_transferability/${tb}/m_out_*_rec1.0e-08_s-0.001_h0.5_p3.vcf.fam)
bfile_h05_p3=${FILE_h05_p3%.fam}
BASENAMES_h05_p3=$(basename "$FILE_h05_p3" .fam)

FILES_betas_h05=(~/PRS_transferability/${tb}/PRS_on_p2/betas_PRS/*_h0.5_p2.vcf*.txt)
FILE_betas_h05=${FILES_betas_h05[$SLURM_ARRAY_TASK_ID-ind]}
BASENAME_betas_h05=$(basename "$FILE_betas_h05" .txt)
BASENAME_h05=${BASENAME_betas_h05#betas_}
echo $BASENAME_h05

plink2 --bfile $bfile_h05_p1 --score $FILE_betas_h05 3 5 9 list-variants --out ~/PRS_transferability/${tb}/PRS_on_p2/compute_PRS/p1p3/p1_$BASENAME_h05
plink2 --bfile $bfile_h05_p3 --score $FILE_betas_h05 3 5 9 list-variants --out ~/PRS_transferability/${tb}/PRS_on_p2/compute_PRS/p1p3/p3_$BASENAME_h05