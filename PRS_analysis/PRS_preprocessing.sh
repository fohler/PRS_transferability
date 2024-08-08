#!/bin/sh
#SBATCH --job-name=PRS_preprocessing_lb_down
#SBATCH --time=16:00:00
#SBATCH --account=ag_igsb_krawitz # for bonna
#SBATCH --array=1-50
#SBATCH --mem=50G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=fohler@uni-bonn.de

module load PLINK
module load R


tb=sim/lb_down/seed_$SLURM_ARRAY_TASK_ID

for f in /home/lfohler/PRS_transferability/${tb}/out_*.vcf
do

# Modify VCFs ----
FILE=${f}
BASENAMES=$(basename "$FILE")
awk 'BEGIN{FS=OFS="\t"} NR>15{$3="ID:"$1":"$2":"$8} {print $0}' $FILE > /home/lfohler/PRS_transferability/${tb}/m_$BASENAMES

# Make bed ----
FILE=(/home/lfohler/PRS_transferability/${tb}/m_$BASENAMES)
plink2 --vcf $FILE --make-bed --out $FILE

# Add pheno and sex ----
FILE_fam=(/home/lfohler/PRS_transferability/${tb}/m_${BASENAMES}.fam)

BASENAMES2=${BASENAMES#out_}
BASENAMES2=${BASENAMES2%.vcf}

FILE_fit=(/home/lfohler/PRS_transferability/${tb}/fitness_sex_${BASENAMES2}.txt)

Rscript /home/lfohler/add_pheno_sex.R $FILE_fit $FILE_fam

# Modify ID bim ----
FILE=(~/PRS_transferability/${tb}/m_${BASENAMES}.bim)
bfile=${FILE%.bim}

awk 'BEGIN{FS=OFS="\t"} {sub(/;.*/,"",$2)} {print $0}' $FILE >  ${bfile}_id.bim

# Make Covariates, no PCA ----
FILE_fam=(/home/lfohler/PRS_transferability/${tb}/m_${BASENAMES}_pheno_sex.fam)
bfile=${FILE_fam%.fam}

awk 'BEGIN {OFS="\t"} { print $1,$2,$5}' $FILE_fam > ${bfile}_no_pc.cov

# Sample into train and test ----
FILE=(/home/lfohler/PRS_transferability/${tb}/m_${BASENAMES}_pheno_sex.fam)
BASENAME=$(basename "$FILE")

Rscript /home/lfohler/sample_train.R $FILE $BASENAME $tb

done
