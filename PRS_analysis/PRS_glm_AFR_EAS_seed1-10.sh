#!/bin/sh
#SBATCH --job-name=PRS_glm_seed1-10_lb_down
#SBATCH --time=10:00:00
#SBATCH --partition=medium
#SBATCH --array=1-100
#SBATCH --mail-type=ALL
#SBATCH --mail-user=fohler@uni-bonn.de
#SBATCH --account=ag_igsb_krawitz # for bonna

module load R

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
tb_R2=sim/lb_down/R2_all/seed_${seed}

FILES_train=(~/PRS_transferability/${tb}/PRS_on_p2/compute_PRS/Train/*.sscore)
TRAIN=${FILES_train[$SLURM_ARRAY_TASK_ID-ind]}
FILES_p1=(~/PRS_transferability/${tb}/PRS_on_p2/compute_PRS/p1p3/p1_*.sscore)
FILE_p1=${FILES_p1[$SLURM_ARRAY_TASK_ID-ind]}
FILES_p3=(~/PRS_transferability/${tb}/PRS_on_p2/compute_PRS/p1p3/p3_*.sscore)
FILE_p3=${FILES_p3[$SLURM_ARRAY_TASK_ID-ind]}

COV=(/home/lfohler/PRS_transferability/${tb}/*p2.vcf_no_pc.cov)
COV_p1=(/home/lfohler/PRS_transferability/${tb}/*p1.vcf_no_pc.cov)
COV_p3=(/home/lfohler/PRS_transferability/${tb}/*p3.vcf_no_pc.cov)

Rscript ~/PRS_glm_AFR_EAS.R $TRAIN $FILE_p1 $FILE_p3 $COV $COV_p1 $COV_p3 $tb $tb_R2

