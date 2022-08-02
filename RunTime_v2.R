# to draw the dimension of variables versus the computation time.
# want to offset of Kendall's tau calculation.

rm(list = ls())

library(microbenchmark)
library(latentcor)
load("/scratch/user/sharkmanhmz/Dissertation_reproducibility/Dissertation_reproducibility/amgutpruned.rdata") # 6482 by 481 matrix.

# plist <- c(2, 5, 10, 20, 50, 100, 200, 300, 400, 481)
# 
# for (dim in c(100, nrow(amgutpruned))){
#   
#   time_K <- time_org <- time_v2 <- matrix(NA, nrow = length(plist), ncol = 6) # the ncol is from microbenchmark print format.
#   # min, Q1, mean, median, Q3, max -> 6 columns are needed.
#   Kendall_sub <- Kcor_sub_org <- Kcor_sub_v2 <- list()
#   
#   for (i in 1:length(plist)){
#     p <- plist[i]
#     subdat <- amgutpruned[1:dim, 1:p]
#     
#     time_K[i, ] <- unlist(print(microbenchmark(Kendall_sub[[i]] <- mixedCCA::Kendall_matrix(subdat), times = 10), unit = "s")[1, 2:7]) # to use fixed unit: "seconds"
#     
#     time_org[i, ] <- unlist(print(microbenchmark(Kcor_sub_org[[i]] <- mixedCCA::estimateR(subdat, type = "trunc", method = "original", tol = 1e-6, verbose = TRUE)$R, times = 2), unit = "s")[1, 2:7]) # to use fixed unit: "seconds"
#     
#     time_v2[i, ] <- unlist(print(microbenchmark(Kcor_sub_v2[[i]] <- mixedCCA::estimateR(subdat, type = "trunc", method = "approx", tol = 1e-6, verbose = TRUE)$R, times = 10), unit = "s")[1, 2:7]) # to use fixed unit: "seconds"
#     
#     cat("Done with n = ", dim, " p = ", p, "\n\n\n")
#   }
#   
#   save(time_K, time_org, time_v2, file = paste0("Data/RunTimePlot_v2_range_", dim, ".Rda"))
# }

library(parallel)
library(doFuture)

X_100_20 = amgutpruned[1:100, 1:20]
X_100_50 = amgutpruned[1:100, 1:50]
X_100_100 = amgutpruned[1:100, 1:100]
X_100_200 = amgutpruned[1:100, 1:200]
X_100_300 = amgutpruned[1:100, 1:300]
X_100_400 = amgutpruned[1:100, 1:400]
X_100_481 = amgutpruned[1:100, 1:ncol(amgutpruned)]
X_6482_20 = amgutpruned[1:nrow(amgutpruned), 1:20]
X_6482_50 = amgutpruned[1:nrow(amgutpruned), 1:50]
X_6482_100 = amgutpruned[1:nrow(amgutpruned), 1:100]
X_6482_200 = amgutpruned[1:nrow(amgutpruned), 1:200]
X_6482_300 = amgutpruned[1:nrow(amgutpruned), 1:300]
X_6482_400 = amgutpruned[1:nrow(amgutpruned), 1:400]
X_6482_481 = amgutpruned[1:nrow(amgutpruned), 1:ncol(amgutpruned)]
registerDoFuture()
plan(multicore, workers = 72)
timing = microbenchmark(latentcor(X = X_100_20, types = "tru", method = "original"), latentcor(X = X_100_20, types = "tru"),
                        latentcor(X = X_100_50, types = "tru", method = "original"), latentcor(X = X_100_50, types = "tru"),
                        latentcor(X = X_100_100, types = "tru", method = "original"), latentcor(X = X_100_100, types = "tru"),
                        latentcor(X = X_100_200, types = "tru", method = "original"), latentcor(X = X_100_200, types = "tru"),
                        latentcor(X = X_100_300, types = "tru", method = "original"), latentcor(X = X_100_300, types = "tru"),
                        latentcor(X = X_100_400, types = "tru", method = "original"), latentcor(X = X_100_400, types = "tru"),
                        latentcor(X = X_100_481, types = "tru", method = "original"), latentcor(X = X_100_481, types = "tru"),
                        latentcor(X = X_6482_20, types = "tru", method = "original"), latentcor(X = X_6482_20, types = "tru"),
                        latentcor(X = X_6482_50, types = "tru", method = "original"), latentcor(X = X_6482_50, types = "tru"),
                        latentcor(X = X_6482_100, types = "tru", method = "original"), latentcor(X = X_6482_100, types = "tru"),
                        latentcor(X = X_6482_200, types = "tru", method = "original"), latentcor(X = X_6482_200, types = "tru"),
                        latentcor(X = X_6482_300, types = "tru", method = "original"), latentcor(X = X_6482_300, types = "tru"),
                        latentcor(X = X_6482_400, types = "tru", method = "original"), latentcor(X = X_6482_400, types = "tru"),
                        latentcor(X = X_6482_481, types = "tru", method = "original"), latentcor(X = X_6482_481, types = "tru"),
                        times = 5L, unit = "s")
save(timing, file = "timing.rda")


