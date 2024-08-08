library(data.table)
args <- commandArgs(trailingOnly = TRUE)

fitnessSex <- read.csv(file = args[1])

fam <- read.csv(file = args[2], sep = "\t", header = FALSE)
colnames(fam) <- c("V1", "ID", "V3", "V4", "V5", "Fitness") # ???

for (i in 1:nrow(fam)) {
    fam$Fitness[i] <- fitnessSex$fitness[i]

     if (fitnessSex$sex[i] == "M"){
      fam$V5[i] <- 1
    } else if (fitnessSex$sex[i] == "F") {
      fam$V5[i] <- 2
    } else {
      fam$V5[i] <- 0
    }
}

fwrite(fam, paste0(gsub('.{4}$', '', args[2]), "_pheno_sex.fam"), sep = "\t", col.names = FALSE, row.names = FALSE)
