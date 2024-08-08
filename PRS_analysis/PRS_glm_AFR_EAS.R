library(data.table)
library(tidyverse)

args <- commandArgs(trailingOnly = TRUE)
PRS_train <- fread(args[1]) # "PRS_train.sscore"
PRS_p1 <- fread(args[2]) # "PRS_p1.sscore"
PRS_p3 <- fread(args[3]) # "PRS_p3.sscore"
cov_train <- fread(args[4]) # "cov_train.cov"
cov_train <- cov_train %>% rename(IID=V2, sex=V3)
cov_p1 <- fread(args[5]) # "cov_p1.cov"
cov_p1 <- cov_p1 %>% rename(IID=V2, sex=V3)
cov_p3 <- fread(args[6]) # "cov_p3.cov"
cov_p3 <- cov_p3 %>% rename(IID=V2, sex=V3)


phe_train <- PRS_train%>% select(IID,PHENO1,SCORE1_AVG) %>% rename(PRS=SCORE1_AVG)
phe_train <- left_join(phe_train, cov_train%>% select(IID:sex), by="IID")

phe_p1 <- PRS_p1%>% select(IID,PHENO1,SCORE1_AVG) %>% rename(PRS=SCORE1_AVG)
phe_p1 <- left_join(phe_p1, cov_p1%>% select(IID:sex), by="IID")

phe_p3 <- PRS_p3%>% select(IID,PHENO1,SCORE1_AVG) %>% rename(PRS=SCORE1_AVG)
phe_p3 <- left_join(phe_p3, cov_p3%>% select(IID:sex), by="IID")

### fit glm with covariates on p1 and p3
model <- glm(PHENO1 ~ 1 + sex + PRS, family=gaussian, data = phe_train)

test_predict_p1 <- predict.glm(model, newdata = phe_p1)
test_predict_p3 <- predict.glm(model, newdata = phe_p3)

r_squared_p1 = cor(phe_p1$PHENO1,test_predict_p1)^2
r_squared_p3 = cor(phe_p3$PHENO1,test_predict_p3)^2

newrow_p1 <- data.frame(args[1], args[2], r_squared_p1)
name <- gsub('^.{5}|.{7}$', '', basename(args[1]))
fwrite(newrow_p1, paste0("~/PRS_transferability/", args[7], "/PRS_on_p2/R2/p1/R2_p1", name, ".txt"), sep="\t")
fwrite(newrow_p1, paste0("~/PRS_transferability/", args[8], "/R2/p1/R2_p1", name, ".txt"), sep="\t")

newrow_p3 <- data.frame(args[1], args[3], r_squared_p3)
name <- gsub('^.{5}|.{7}$', '', basename(args[1]))
fwrite(newrow_p3, paste0("~/PRS_transferability/", args[7], "/PRS_on_p2/R2/p3/R2_p3", name, ".txt"), sep="\t")
fwrite(newrow_p3, paste0("~/PRS_transferability/", args[8], "/R2/p3/R2_p3", name, ".txt"), sep="\t")
