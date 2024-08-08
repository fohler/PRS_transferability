library(data.table)
library(dplyr)
args <- commandArgs(trailingOnly = TRUE)

snps <- fread(file = args[1], sep = "\t") # .snp

betas <- fread(file = args[2], sep = "\t") # .linear

PRSice_summary <- fread(file = args[3], sep = "\t") # .summary

snps <- snps %>% filter(P < PRSice_summary$Threshold)

betas_PRS <- betas %>% filter(ID %in% snps$SNP)

name <- gsub('^.{7}|.{4}$', '', basename(args[1]))
fwrite(betas_PRS, paste0("~/PRS_transferability/", args[4], "/PRS_on_p2/betas_PRS/betas_", name, ".txt"), col.names = FALSE, sep="\t")
