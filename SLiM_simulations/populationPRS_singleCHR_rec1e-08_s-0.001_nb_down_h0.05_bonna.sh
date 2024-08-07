#!/bin/sh
#SBATCH --job-name=slim_nb_down_h0.05
#SBATCH --time=2-00:00:00
#SBATCH --account=ag_igsb_krawitz
#SBATCH --partition=medium
#SBATCH --array=1-50
#SBATCH --mem=120G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=fohler@uni-bonn.de
module load SLiM
slim -s $SLURM_ARRAY_TASK_ID -d h=0.05 -d n_b=1000 -d l_b=1000 -d r_exp=0.002449559 -d n_fin=10000  /home/lfohler/populationPRS_singleCHR_rec1e-08_s-0.001_nb_down_h_bonna.slim
wait
