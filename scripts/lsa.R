library(lsa)

#zmiana katalogu roboczego
workDir <- "C:\\Users\\Kamil\\Desktop\\KR\\TextMining12S"
setwd(workDir)


#lokalizacja katalogu ze skryptami
scriptsDir <- ".\\scripts"

#za�adowanie skryptu
sourceFile <- paste(
  scriptsDir,
  "\\",
  "frequency_matrix.R",
  sep = ""
)
source(sourceFile)

#analiza ukrytych wymiar�w semantycznych (dekompozycja wg warto�ci osobliwych)
lsa <- lsa(tdmTfidfBoundsMatrix)
lsa$tk #odpowiednik macierzy U, wsp�rz�dne wyraz�w
lsa$dk #odpowiednik macierzy V, wsp�rz�dne dokument�w
lsa$sk #odpowiednik macierzy D, znaczenie sk�adowych

#Tu sko�czyli�my
#przygotowanie wsp�rz�dnych do wykresu
x <- pca$x[,1]
y <- pca$x[,2]

#przygotowanie legendy
legend <- paste(
  paste("d", 1:length(rownames(dtmTfidfBoundsMatrix)),sep = ""),
  rownames(dtmTfidfBoundsMatrix),
  sep = "<-"
)

#wykres dokument�w w przestrzeni dwuwymiarowej
plot(
  x,
  y,
  #xlim = c(-0.5,-0.2),
  #ylim = c(-0.2,0.1),
  xlab="Wsp�rz�dna syntetyczna 1", 
  ylab="Wsp�rz�dna syntetyczna 2",
  main="Analiza g��wnych sk�adowych", 
  col = "orange"
)
text(
  x, 
  y, 
  labels = paste("d", 1:length(rownames(dtmTfidfBoundsMatrix)),sep = ""), 
  pos = 3,
  col = "orange"
)
legend("bottom", legend, cex=.5, text.col = "orange")

#eksport wykresu do pliku .png
plotFile <- paste(
  outputDir,
  "\\",
  "pca.png",
  sep = ""
)
png(file = plotFile)
plot(
  x,
  y,
  xlab="Wsp�rz�dna syntetyczna 1", 
  ylab="Wsp�rz�dna syntetyczna 2",
  main="Analiza g��wnych sk�adowych", 
  col = "orange"
)
text(
  x, 
  y, 
  labels = paste("d", 1:length(rownames(dtmTfidfBoundsMatrix)),sep = ""), 
  pos = 3,
  col = "orange"
)
legend("bottom", legend, cex=.65, text.col = "orange")
dev.off()
