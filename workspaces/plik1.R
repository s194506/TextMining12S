#wlaczenie bibliotek
library(tm)

#zmiana katalogu roboczego
workDir <- "D:\\KR-194\\PJN\\TextMining12S"
#zmienia lokalizacje katalogu roboczego na ta podana w zmiennej
setwd(workDir)

#definicja katalogow projektow
inputDir <- ".\\data"
outputDir <- ".\\results"
scriptsDir <- ".\\scripts"

dir.create(outputDir, showWarnings = FALSE)

corpusDir <- paste(inputDir, "\\","Literatura - streszczenia - oryginał",
                   sep = "")

corpus <- VCorpus(
  DirSource(corpusDir, pattern = "*.txt", encoding = "UTF-8"),
  readerControl = list(language = "pl_PL")
)
