#!/bin/bash
#SBATCH --job-name=train_seed1-10_lb_down
#SBATCH --time=05:00:00
#SBATCH --partition=short
#SBATCH --account=ag_igsb_krawitz # for bonna
#SBATCH --mail-type=ALL
#SBATCH --mail-user=fohler@uni-bonn.de
#SBATCH --array=1-100
#SBATCH --mem=50G
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

directory=/home/lfohler/PRS_transferability/sim/lb_down/seed_${seed}
pop=p2 # base population

trainIIDsh_0_5=(${directory}/train_IID/*h0.5_${pop}*)
trainIIDh0_5=${trainIIDsh_0_5[$SLURM_ARRAY_TASK_ID-ind]}
BASENAMEh0_5_IID=$(basename "$trainIIDh0_5" .txt)

FILEh0_5=(${directory}/m_out_*_rec1.0e-08_s-0.001_h0.5_${pop}.vcf.bed)
bfileh0_5=${FILEh0_5%.bed}
BASENAMEh0_5=$(basename "$FILEh0_5" .bed)

plink2 --bfile $bfileh0_5 --remove $trainIIDh0_5 --make-bed --out ${directory}/PRS_on_${pop}/TestSet/test_$BASENAMEh0_5_IID
plink2 --bfile $bfileh0_5 --keep $trainIIDh0_5 --make-bed --out ${directory}/PRS_on_${pop}/TrainSet/train_$BASENAMEh0_5_IID