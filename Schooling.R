rm(list = ls())
library(Ecdat)
data("Schooling")
head(Schooling, n = 6L)
apply(Schooling, 2, unique)
mar76 = rep(0, dim(Schooling["mar76"])[1])
mar76[Schooling["mar76"] == "yes"] = 1 
schooling = data.matrix(Schooling)
#apply(schooling[ , c(1,2,3,4,5,6,11,13,14,15,16,17,18,21,23,27)], 2, unique)
schooling[ , c(1,2,3,4,5,6,11,13,14,15,16,17,18,21,23,27)] = schooling[ , c(1,2,3,4,5,6,11,13,14,15,16,17,18,21,23,27)] - 1
schooling[ , 26] = mar76
print(schooling[1:6, ])
print(Schooling[1:6, ])
apply(schooling, 2, unique)
library(latentcor)
types = get_types(schooling)
library(microbenchmark)
microbenchmark(latentcor(schooling, types = types, method = "original"),
               latentcor(schooling, types = types, method = "approx"), times = 5L)
               