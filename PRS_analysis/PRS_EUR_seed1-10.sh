#!/bin/bash
#SBATCH --job-name=PRS_EUR_seed1-10_lb_down
#SBATCH --time=5:00:00
#SBATCH --account=ag_igsb_krawitz # for bonna
#SBATCH --mail-type=ALL
#SBATCH --mail-user=fohler@uni-bonn.de
#SBATCH --partition=short
#SBATCH --array=1-100
#SBATCH --mem=50G

module load PLINK
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

# GWAS ----
FILES=(/home/lfohler/PRS_transferability/${tb}/PRS_on_p2/TrainSet/*.fam)
FILE=${FILES[$SLURM_ARRAY_TASK_ID-ind]}
BASENAMES=$(basename "$FILE" .fam)

COV=(/home/lfohler/PRS_transferability/${tb}/*p2.vcf_no_pc.cov)

plink2 --bfile /home/lfohler/PRS_transferability/${tb}/PRS_on_p2/TrainSet/$BASENAMES --maf 0.01 --glm omit-ref hide-covar --covar ${COV} --output-min-p 1e-301 --out /home/lfohler/PRS_transferability/${tb}/PRS_on_p2/gwas_train/gwas_$BASENAMES


# PRSice ----
BASEFILE=(/home/lfohler/PRS_transferability/${tb}/PRS_on_p2/gwas_train/gwas_${BASENAMES}.PHENO1.glm.linear)
FILES_target=(/home/lfohler/PRS_transferability/${tb}/PRS_on_p2/TestSet/*.fam)
FILE_target=${FILES_target[$SLURM_ARRAY_TASK_ID-ind]}
TARGETFILE=${FILE_target%.fam}
OUT=$(basename "$FILE_target" .fam)

Rscript ~/PRSice.R --dir . \
    --prsice ~/PRSice_linux \
    --base $BASEFILE \
    --target $TARGETFILE \
    --thread 1 \
    --snp 2 \
    --chr 0 \
    --bp 1 \
    --A1 4 \
    --A2 3 \
    --stat 8 \
    --pvalue 11 \
    --beta \
    --binary-target F \
    --index \
    --keep-ambig \
    --print-snp \
    --cov $COV \
    --out /home/lfohler/PRS_transferability/${tb}/PRS_on_p2/PRSice_train_test/PRSice_$OUT

# Extract betas ----
SNP=(/home/lfohler/PRS_transferability/${tb}/PRS_on_p2/PRSice_train_test/PRSice_${OUT}.snp)
BETAS=(/home/lfohler/PRS_transferability/${tb}/PRS_on_p2/gwas_train/gwas_${BASENAMES}.PHENO1.glm.linear)
SUMMARY=(/home/lfohler/PRS_transferability/${tb}/PRS_on_p2/PRSice_train_test/PRSice_${OUT}.summary)

Rscript ~/extract_betas.R $SNP $BETAS $SUMMARY $tb

# Compute PRS ----
bfile_train=${FILE%.fam}
BASENAMES_train=$(basename "$FILE" .fam)

FILE_betas=(/home/lfohler/PRS_transferability/${tb}/PRS_on_p2/betas_PRS/betas_${OUT}.txt)

plink2 --bfile $bfile_train --score $FILE_betas 3 5 9 list-variants --out ~/PRS_transferability/${tb}/PRS_on_p2/compute_PRS/Train/$BASENAMES_train
plink2 --bfile $TARGETFILE --score $FILE_betas 3 5 9 list-variants --out ~/PRS_transferability/${tb}/PRS_on_p2/compute_PRS/Test/$OUT


# PRS glm ----
TRAIN=(~/PRS_transferability/${tb}/PRS_on_p2/compute_PRS/Train/${BASENAMES_train}.sscore)
TEST=(~/PRS_transferability/${tb}/PRS_on_p2/compute_PRS/Test/${OUT}.sscore)

Rscript ~/PRS_glm_EUR.R $TRAIN $TEST $COV $tb $tb_R2
