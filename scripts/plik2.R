library(tm)
library(stringr)

#zmiana katalogu roboczego
workDir <- "C:\\Users\\Kamil\\Desktop\\KR\\TextMining12S"
setwd(workDir)

#definicja katalogow projektu
inputDir <- ".\\data"
outputDir <- ".\\results"
scriptsDir <- ".\\scripts"
workspaceDir <- ".\\workspaces"

#utworzenie katalogu wyjsciowego
dir.create(outputDir, showWarnings = FALSE)
dir.create(workspaceDir, showWarnings = FALSE)

#utworzenie korpusu dokumentoww
corpusDir <- paste(
  inputDir,
  "\\",
  "Literatura - streszczenia - przetworzone",
  sep = ""
)
corpus <- VCorpus(
  DirSource(
    corpusDir,
    pattern = "*.txt",
    encoding = "UTF-8"
  ),
  readerControl = list(
    language = "pl_PL"
  )
)

#usuniecie rozszerzen z nazw dokumentow
cutExtension <- function(document) {
  meta(document, "id") <- gsub(pattern = "\\.txt$", "", meta(document, "id"))
  return(document)
}

corpus <- tm_map (corpus, cutExtension)

#utworzenie macierzy czestosci
tdmTfAll <- TermDocumentMatrix(corpus)
dtmTfAll <- DocumentTermMatrix(corpus)
tdmTfidAll <- TermDocumentMatrix(
  corpus,
  control = list(
    weighting = weightTfIdf
  )
)

tdmBin <- TermDocumentMatrix(
  corpus,
  control = list(
    weighting = weightBin
  )
)
tdmTfBounds <- TermDocumentMatrix(
  corpus,
  control = list(
    bounds = list(
      global = c(2,16)
    )
  )
)
tdmTfIdfBounds <- TermDocumentMatrix(
  corpus,
  control = list(
    weighting = weightTfIdf,
    bounds = list(
      global = c(2,16)
    )
  )
)

#konwersja
tdmTfAllMatrix <- as.matrix(tdmTfAll)
dtmTfAllMatrix <- as.matrix(dtmTfAll)
tdmTfidfAllMatrix <- as.matrix(tdmTfidAll)
tdmBinAllMatrix <- as.matrix(tdmBin)
tdmTfBoundsMatrix <- as.matrix(tdmTfBounds)
tdmTfidfBoundsMatrix <- as.matrix(tdmTfIdfBounds)

#matrixFile <- paste(
#  outputDir,
# "\\",
#  "tdmTfidBounds.csv",
#  sep=""
#)
#write.table(tdmTfidfBoundsMatrix, file = matrixFile, sep=";",dec=",",col.names = NA)

#skalowanie wielowymiarowe

