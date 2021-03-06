
# adapted from: https://github.com/bedatadriven/activityinfo-R/blob/development/inst/ci-build.R
# ieuan clay
# may 2015

### run all benchmarks in genbench
# needs info about path and what size of data to run on
args <- commandArgs(trailingOnly = TRUE)
ENGINE <- "Renjin"
##### To be excluded workflows due to crashing the benchmark process:
PATTERN <- "affy|clinical|huber|integration|levesque|microarray|mrna_seq|mutation|simple_survival|simulated_GEO_matrix|survival"
allWorkflows <- dir(file.path(getwd(), "code"), full.names = TRUE, recursive = TRUE, pattern = "\\.R$", ignore.case = TRUE)
includeWorkflows <- allWorkflows[!is.element(allWorkflows,allWorkflows[grep(PATTERN,allWorkflows,ignore.case=T)])]
excludedWorkflows <- allWorkflows[grep(PATTERN,allWorkflows,ignore.case=T)]
#####
if (length(args) > 0) {
  NRUNS <- as.integer(args[1])
  cat(sprintf("Using %i runs per benchmark\n", NRUNS))

} else {
  NRUNS <- 1
  cat(sprintf("Using default number of runs (%i)\n", as.integer(NRUNS)))
}

# find and run all benchmark scripts
cat("\nThe following scripts will be runned: \n")
sprintf(includeWorkflows)
cat("\nThe following scripts will be excluded: \n")
sprintf(excludedWorkflows)
for (SCRIPT in includeWorkflows){
  # run benchmark script
  cat(timestamp(quiet = TRUE), "Running benchmark at ", SCRIPT,"\n")
  for (x in 1:NRUNS){
    cat(sprintf("\t>>>Run %i\n", x))
    # all scripts assume working dir is same as script
    # each script run in a fresh local environment
    try({source(SCRIPT, chdir = TRUE, local=new.env())})
  }
  cat(timestamp(quiet = TRUE), "Finished running benchmark at ", SCRIPT,"\n")
}
