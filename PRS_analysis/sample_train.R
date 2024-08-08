library(data.table)

args <- commandArgs(trailingOnly = TRUE)
fam <- read.csv(file = args[1], sep = "\t")

for (i in 0:9) { # number of samples
  set.seed(i)
  name <- gsub('.{4}$', '', args[2])
  trainIID <- data.frame(sample(fam[,2], floor(nrow(fam) * 0.8)))
  fwrite(trainIID, paste0("/home/lfohler/PRS_transferability/", args[3], "/train_IID/", name, "_trainIID_seed", i, ".txt"), col.names = FALSE)
}
