#!/bin/sh
#SBATCH --job-name=run_slim
#SBATCH --time=5-00:00:00
#SBATCH --account=ag_igsb_krawitz
#SBATCH --partition=long
#SBATCH --array=1-3
#SBATCH --mem=96G
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=fohler@uni-bonn.de
module load SLiM/3.7-GCC-10.3.0
slim -s $SLURM_ARRAY_TASK_ID /home/lfohler/populationPRS_singleCHR_rec1e-08_s-0.001_historic_bonna.slim
wait
