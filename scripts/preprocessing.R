#wlaczenie bibliotek
library(tm)
library(hunspell)
library(stringr)

#zmiana katalogu roboczego
workDir <- "C:\\Users\\Kamil\\Desktop\\KR\\TextMining12S"
#zmienia lokalizacje katalogu roboczego na ta podana w zmiennej
setwd(workDir)

#definicja katalogow projektow
inputDir <- ".\\data"
outputDir <- ".\\results"
scriptsDir <- ".\\scripts"
workspaceDir <- ".\\workspaces"

dir.create(workspaceDir, showWarnings = FALSE)
dir.create(workspaceDir, showWarnings = FALSE)

corpusDir <- paste(inputDir,
                   "\\",
                   "Literatura - streszczenia - oryginal",
                   sep = ""
)

corpus <- VCorpus(
  DirSource(
    corpusDir,
    pattern = "*.txt",
    encoding = "UTF-8"),
  readerControl = list(
    language = "pl_PL")
)

#usuni�cie z tekst�w podzia�u na akapity
pasteParagraphs <- content_transformer(function(text, char) paste(text, collapse = char))
corpus <- tm_map(corpus, " ")

#wst�pne przetwarzanie
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, content_transformer(tolower))
stoplistFile <- paste(
  inputDir,
  "\\",
  "stopwords_pl.txt",
  sep = ""
)
stoplist <- readLines(
  stoplistFile,
  encoding = "UTF-8"
)
corpus <- tm_map(corpus, removeWords, stoplist)
corpus <- tm_map(corpus, stripWhitespace)

removeChar <- content_transformer(
  function(x, pattern, replacement) 
    gsub(pattern, replacement, x)
)

#usuni�cie "em dash" i 3/4 z tekst�w
corpus <- tm_map(corpus, removeChar, intToUtf8(8722), "")
corpus <- tm_map(corpus, removeChar, intToUtf8(190), "")

#lematyzacja - sprowadzenie do formy podstawowej
polish <- dictionary(lang = "pl_PL")

lemmatize <- function(text) {
  simpleText <- str_trim(as.character(text))
  parsedText <- strsplit(simpleText, split = " ")
  newTextVec <- hunspell_stem(parsedText[[1]], dict = polish)
  for (i in 1:length(newTextVec)){
    if (length(newTextVec[[i]]) == 0) newTextVec[i] <- parsedText[[1]][i]
    if (length(newTextVec[[i]]) > 1) newTextVec[i] <- newTextVec[[i]][1]
  }
  newText <- paste(newTextVec, collapse = " ")
  return(newText)
}

corpus <- tm_map(corpus, content_transformer(lemmatize))

#usuni�cie rozszerze� z nazw dokument�w
cutExtensions <- function(document) {
  meta(document, "id") <- gsub(pattern = "\\.txt$", "", meta(document, "id"))
  return(document)
}

corpus <- tm_map(corpus, cutExtensions)

#eksport korpusu przetworzonego do plik�w tekstowych
preprocessedDir <- paste(
  outputDir,
  "\\",
  "Literatura - streszczenia - przetworzone",
  sep = ""
)
dir.create(preprocessedDir, showWarnings = FALSE)
writeCorpus(corpus, path = preprocessedDir)

