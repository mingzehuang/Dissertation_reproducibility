# to draw the dimension of variables versus the computation time.
# want to offset of Kendall's tau calculation.

rm(list = ls())

library(parallel)
library(microbenchmark)
library(latentcor)
library(doFuture)
library(doRNG)
#plan(future.batchtools::batchtools_slurm)
load("/scratch/user/sharkmanhmz/Dissertation_reproducibility/Dissertation_reproducibility/amgutpruned.rdata") # 6482 by 481 matrix.
plist = rbind(rep(c(100, 6482), 7), rep(c(20, 50, 100, 200, 300, 400, 481), each = 2))
registerDoFuture()
plan(multicore, workers = 72)
value = 
  foreach (i = 1:ncol(plist), .combine = rbind) %dorng% {
  n = plist[1, i]; p = plist[2, i]
  time_org <- time_v2 <- NULL
  subdat <- amgutpruned[1:n, 1:p]
  time_org <- median(microbenchmark(latentcor(subdat, types = "tru", method = "original")$R, times = 2, unit = "s")$time) # to use fixed unit: "seconds"
  time_v2 <- median(microbenchmark(latentcor(subdat, types = "tru", method = "approx")$R, times = 10, unit = "s")$time) # to use fixed unit: "seconds"
  valuelist = c(time_org, time_v2)
}
save(value, file = "RunTimePlot_v2.Rda")

# X_100_20 = amgutpruned[1:100, 1:20]
# X_100_50 = amgutpruned[1:100, 1:50]
# X_100_100 = amgutpruned[1:100, 1:100]
# X_100_200 = amgutpruned[1:100, 1:200]
# X_100_300 = amgutpruned[1:100, 1:300]
# X_100_400 = amgutpruned[1:100, 1:400]
# X_100_481 = amgutpruned[1:100, 1:ncol(amgutpruned)]
# X_6482_20 = amgutpruned[1:nrow(amgutpruned), 1:20]
# X_6482_50 = amgutpruned[1:nrow(amgutpruned), 1:50]
# X_6482_100 = amgutpruned[1:nrow(amgutpruned), 1:100]
# X_6482_200 = amgutpruned[1:nrow(amgutpruned), 1:200]
# X_6482_300 = amgutpruned[1:nrow(amgutpruned), 1:300]
# X_6482_400 = amgutpruned[1:nrow(amgutpruned), 1:400]
# X_6482_481 = amgutpruned[1:nrow(amgutpruned), 1:ncol(amgutpruned)]
# registerDoFuture()
# plan(multisession, workers = 72)
# timing = microbenchmark(latentcor(X = X_100_20, types = "tru", method = "original"), latentcor(X = X_100_20, types = "tru"),
#                         latentcor(X = X_100_50, types = "tru", method = "original"), latentcor(X = X_100_50, types = "tru"),
#                         latentcor(X = X_100_100, types = "tru", method = "original"), latentcor(X = X_100_100, types = "tru"),
#                         latentcor(X = X_100_200, types = "tru", method = "original"), latentcor(X = X_100_200, types = "tru"),
#                         latentcor(X = X_100_300, types = "tru", method = "original"), latentcor(X = X_100_300, types = "tru"),
#                         latentcor(X = X_100_400, types = "tru", method = "original"), latentcor(X = X_100_400, types = "tru"),
#                         latentcor(X = X_100_481, types = "tru", method = "original"), latentcor(X = X_100_481, types = "tru"),
#                         latentcor(X = X_6482_20, types = "tru", method = "original"), latentcor(X = X_6482_20, types = "tru"),
#                         latentcor(X = X_6482_50, types = "tru", method = "original"), latentcor(X = X_6482_50, types = "tru"),
#                         latentcor(X = X_6482_100, types = "tru", method = "original"), latentcor(X = X_6482_100, types = "tru"),
#                         latentcor(X = X_6482_200, types = "tru", method = "original"), latentcor(X = X_6482_200, types = "tru"),
#                         latentcor(X = X_6482_300, types = "tru", method = "original"), latentcor(X = X_6482_300, types = "tru"),
#                         latentcor(X = X_6482_400, types = "tru", method = "original"), latentcor(X = X_6482_400, types = "tru"),
#                         latentcor(X = X_6482_481, types = "tru", method = "original"), latentcor(X = X_6482_481, types = "tru"),
#                         times = 5L, unit = "s")
# save(timing, file = "timing.rda")



