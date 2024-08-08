library(data.table)
library(tidyverse)

args <- commandArgs(trailingOnly = TRUE)
PRS_train <- fread(args[1]) # "PRS_train.sscore"
PRS_test <- fread(args[2]) # "PRS_test.sscore"
cov <- fread(args[3]) # "cov.cov"
cov <- cov %>% rename(IID=V2, sex=V3)

phe_train <- PRS_train%>% select(IID,PHENO1,SCORE1_AVG) %>% rename(PRS=SCORE1_AVG)
phe_train <- left_join(phe_train, cov%>% select(IID:sex), by="IID")

phe_test <- PRS_test%>% select(IID,PHENO1,SCORE1_AVG) %>% rename(PRS=SCORE1_AVG)
phe_test <- left_join(phe_test, cov%>% select(IID:sex), by="IID")

### fit glm with covariates on train
model <- glm(PHENO1 ~ 1 + sex + PRS, family=gaussian, data = phe_train)

test_predict <- predict.glm(model, newdata = phe_test)

r_squared = cor(phe_test$PHENO1,test_predict)^2

newrow <- data.frame(args[1], args[2], r_squared)
name <- gsub('^.{5}|.{7}$', '', basename(args[1]))
fwrite(newrow, paste0("~/PRS_transferability/", args[4], "/PRS_on_p2/R2/R2", name, ".txt"), sep="\t")
fwrite(newrow, paste0("~/PRS_transferability/", args[5], "/R2/R2", name, ".txt"), sep="\t")
