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
workspaceDir <- ".\\workspaces"

dir.create(workspaceDir, showWarnings = FALSE)

corpusDir <- paste(inputDir, "\\","Literatura - streszczenia - oryginał",
                   sep = "")

corpus <- VCorpus(
  DirSource(corpusDir, pattern = "*.txt", encoding = "UTF-8"),
  readerControl = list(language = "pl_PL")
)

#wstepne przetwarzanie 
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, content_transformer(tolower))
#def lokalizacja
stoplistFile <- paste(inputDir, "\\","stopwords_pl.txt",
                      sep = "")
#odczytuje linie
stoplist <- readLines(stoplistFile, encoding = "UTF-8")
#usuwam
corpus <- tm_map(corpus, removeWords, stoplist)
corpus <- tm_map(corpus, stripWhitespace)
