
# Import de librairies
library(shiny)
library("FactoMineR")
library("stringdist")


#import des plug ins
source("plug-ins/AdditionnalMethod.R")
source("plug-ins/AlgoPersonalisee.R")


## -------------------------------------------------- Variables pour l'IHM: --------------------------------------------------------------------------

#searchSeqList = le fichier texte contenant les séquences biologiques à ajouter aux jeux de séquences déjà classifiés

#mode = Utilisation d'un algorithme de calcul de distance déjà implémenté dans R (valeur = 'default'), 
#    ou utilisation d'un algorithme de calcul de distance pesonnalisé, implémenté dans le fichier algoPersonnalisee.R (valeur = 'custom') 

#AlgoAUtiliser = le nom de l'algorithme de calcul de distance à utiliser (si mode = default)

# ----------------------------------------------------------------------------------------------------------------------------------------------------


# Programme principal
runAlgo2 = function(searchSeqList,
                    mode,
                    AlgoAUtiliser){

  #La variable qui va servir à afficher les résultats en sortie
  toDisp = c()
  
  for(ind in 1:length(searchSeqList)){
    
    ## Déterminer les distances entre les classes et l'élément courant:
    
    # initialisation
    meanVecteur = c()
    nbClasse = 1
    fileNameSeq = paste("result/resultat_sequences_classe",as.character(nbClasse),".txt", sep = "")
    while(file.exists(fileNameSeq) == TRUE){
    
      # Importation des jeux de séquences classés
      rawData = read.table(fileNameSeq, header=FALSE, sep="")
      rawColData = rawData[,1]
      dataVect = as.vector(rawColData)
    
      #construction d'un vecteur dist
      distVecteur = c()
      for(i in 1:length(dataVect)){
        if(mode == 'default'){
          distVecteur = append(distVecteur, stringdist(as.character(dataVect[i]), as.character(searchSeqList[ind]), method = AlgoAUtiliser))
        }else if(mode == 'custom'){
          seq1 = seqToVect(as.character(dataVect[i]))
          seq2 = seqToVect(as.character(searchSeqList[ind]))
          distVecteur = append(distVecteur, algoDistCustom(seq1, seq2))
        }
      }
      meanVecteur = append(meanVecteur, mean(distVecteur))
    
      # Hérédité
      nbClasse = nbClasse+1
      fileNameSeq = paste("result/resultat_sequences_classe",as.character(nbClasse),".txt", sep = "")
    
    }
    
    # Selection de la distance la plus courte
    resRank = which.min(meanVecteur)
    
    # Affectation de la séquence à sa classe
    fileNameSeq = paste("result/resultat_sequences_classe",as.character(resRank),".txt", sep = "")
    write(as.character(searchSeqList[ind]), fileNameSeq, ncolumns = 1, append = TRUE)
    
    # Ajout des informations à afficher à la sortie
    toDisp = append(toDisp, searchSeqList[ind])
    toDisp = append(toDisp, as.character(resRank))
    
  }
  
  # Mise en forme du résultat à afficher
  matToDisp = matrix(toDisp, ncol = 2, byrow = TRUE)
  colnames(matToDisp) = c("sequences", "classe d'affectation")
  return(matToDisp)
  
}