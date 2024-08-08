#!/bin/sh
#SBATCH --job-name=geno-counts_lb_down
#SBATCH --time=2:00:00
#SBATCH --account=ag_igsb_krawitz # for bonna
#SBATCH --array=1-50
#SBATCH --mem=50G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=fohler@uni-bonn.de

tb=sim/lb_down
tb_h05=sim/lb_down/seed_$SLURM_ARRAY_TASK_ID
tb_h005=sim/lb_down/h_0.05/seed_$SLURM_ARRAY_TASK_ID
tb_h08=sim/lb_down/h_0.8/seed_$SLURM_ARRAY_TASK_ID


module load PLINK

FILEh0_5=(~/PRS_transferability/${tb_h05}/m_out_*_rec1.0e-08_s-0.001_h0.5_p2.vcf.bed)
bfileh0_5=${FILEh0_5%.bed}
BASENAMEh0_5=$(basename "$FILEh0_5" .bed)
plink2 --bfile ${bfileh0_5} --geno-counts --out ~/PRS_transferability/$tb/geno-count/${BASENAMEh0_5}

FILEh0_5=(~/PRS_transferability/${tb_h05}/m_out_*_rec1.0e-08_s-0.001_h0.5_p1.vcf.bed)
bfileh0_5=${FILEh0_5%.bed}
BASENAMEh0_5=$(basename "$FILEh0_5" .bed)
plink2 --bfile ${bfileh0_5} --geno-counts --out ~/PRS_transferability/$tb/geno-count/${BASENAMEh0_5}

FILEh0_5=(~/PRS_transferability/${tb_h05}/m_out_*_rec1.0e-08_s-0.001_h0.5_p3.vcf.bed)
bfileh0_5=${FILEh0_5%.bed}
BASENAMEh0_5=$(basename "$FILEh0_5" .bed)
plink2 --bfile ${bfileh0_5} --geno-counts --out ~/PRS_transferability/$tb/geno-count/${BASENAMEh0_5}



FILEh0_05=(~/PRS_transferability/${tb_h005}/m_out_*_rec1.0e-08_s-0.001_h0.05_p2.vcf.bed)
bfileh0_05=${FILEh0_05%.bed}
BASENAMEh0_05=$(basename "$FILEh0_05" .bed)
plink2 --bfile ${bfileh0_05} --geno-counts --out ~/PRS_transferability/$tb/geno-count/${BASENAMEh0_05}

FILEh0_05=(~/PRS_transferability/${tb_h005}/m_out_*_rec1.0e-08_s-0.001_h0.05_p1.vcf.bed)
bfileh0_05=${FILEh0_05%.bed}
BASENAMEh0_05=$(basename "$FILEh0_05" .bed)
plink2 --bfile ${bfileh0_05} --geno-counts --out ~/PRS_transferability/$tb/geno-count/${BASENAMEh0_05}

FILEh0_05=(~/PRS_transferability/${tb_h005}/m_out_*_rec1.0e-08_s-0.001_h0.05_p3.vcf.bed)
bfileh0_05=${FILEh0_05%.bed}
BASENAMEh0_05=$(basename "$FILEh0_05" .bed)
plink2 --bfile ${bfileh0_05} --geno-counts --out ~/PRS_transferability/$tb/geno-count/${BASENAMEh0_05}



FILEh0_8=(~/PRS_transferability/${tb_h08}/m_out_*_rec1.0e-08_s-0.001_h0.8_p2.vcf.bed)
bfileh0_8=${FILEh0_8%.bed}
BASENAMEh0_8=$(basename "$FILEh0_8" .bed)
plink2 --bfile ${bfileh0_8} --geno-counts --out ~/PRS_transferability/$tb/geno-count/${BASENAMEh0_8}

FILEh0_8=(~/PRS_transferability/${tb_h08}/m_out_*_rec1.0e-08_s-0.001_h0.8_p1.vcf.bed)
bfileh0_8=${FILEh0_8%.bed}
BASENAMEh0_8=$(basename "$FILEh0_8" .bed)
plink2 --bfile ${bfileh0_8} --geno-counts --out ~/PRS_transferability/$tb/geno-count/${BASENAMEh0_8}

FILEh0_8=(~/PRS_transferability/${tb_h08}/m_out_*_rec1.0e-08_s-0.001_h0.8_p3.vcf.bed)
bfileh0_8=${FILEh0_8%.bed}
BASENAMEh0_8=$(basename "$FILEh0_8" .bed)
plink2 --bfile ${bfileh0_8} --geno-counts --out ~/PRS_transferability/$tb/geno-count/${BASENAMEh0_8}

