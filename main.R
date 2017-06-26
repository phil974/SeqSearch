
# Import de librairies
library(shiny)
library("FactoMineR")
library("stringdist")


#import des plug ins
source("plug-ins/AdditionnalMethod.R")
source("plug-ins/AlgoPersonalisee.R")


## -------------------------------------------------- Variables pour l'IHM: --------------------------------------------------------------------------

#dataVect = Le fichier texte contenant les séquences biologiques

#dataVect_var = Le fichier texte contenant les activités liées aux séquences biologiques

#mode = Utilisation d'un algorithme de calcul de distance déjà implémenté dans R (valeur = 'default'), 
#    ou utilisation d'un algorithme de calcul de distance pesonnalisé, implémenté dans le fichier algoPersonnalisee.R (valeur = 'custom') 

#AlgoAUtiliser = le nom de l'algorithme de calcul de distance à utiliser (si mode = default)

#MontrerLeGrapheHCPC = affiche de dendrogramme après exécution de la classification hiérarchique (fonctionne uniquement en console pour le moment)

#NombreDeClassesPourHCPC = nombre de classes à avoir après exécution de la classification hiérarchique

#createFolder = génére ou non les fichiers texte contenant les données classées

# ----------------------------------------------------------------------------------------------------------------------------------------------------



# Le programme principal
runAlgo = function(
                   dataVect,
                   dataVect_var,
                   mode,
                   AlgoAUtiliser,
                   MontrerLeGrapheHCPC,
                   NombreDeClassesPourHCPC,
                   createFolder){
    

  # Juste pour être sûr que ce sont bien des vecteurs...
  dataVect = as.vector(dataVect)
  dataVect_var = as.vector(dataVect_var)
  
  # Initialisation de la matrice distance
  matrice_dist = matrix(0, length(dataVect), length(dataVect))
  
  # remplissage de la matrice distance

  if(mode == 'default'){
    for(i in 1:length(dataVect)-1){
      for(j in i:length(dataVect)){
        matrice_dist[i,j] = stringdist(as.character(dataVect[i]), as.character(dataVect[j]), method = AlgoAUtiliser)
      }
    }
    matrice_dist = matrice_dist + t(matrice_dist)
    
  }else if(mode == 'custom'){
    for(i in 1:length(dataVect)){
      for(j in 1:length(dataVect)){
        seq1 = seqToVect(as.character(dataVect[i]))
        seq2 = seqToVect(as.character(dataVect[j]))
        matrice_dist[i,j] = algoDistCustom(seq1, seq2)
      }
    }
  }

  
  # Execution d'HCPC et récupération des résultats
  dfMatriceDist = as.data.frame(matrice_dist)
  hcpc_res = HCPC(dfMatriceDist, nb.clust = NombreDeClassesPourHCPC, graph = MontrerLeGrapheHCPC)
  clustered_frame = hcpc_res$data.clust[,length(dataVect)+1]
  clustList = as.vector(clustered_frame)
  
  
  if(createFolder == TRUE){
  # Remplissage des fichiers
  meanList = c()
  for(cl in 1:getNumberOfClass(clustList)){
    fileNameSeq = paste("result/resultat_sequences_class",as.character(cl),".txt", sep = "")
    fileNameAct = paste("result/resultat_activites_class",as.character(cl),".txt", sep = "")
    file.create(fileNameSeq)
    file.create(fileNameAct)
    clusteredListSeq = c()
    clusteredListAct = c()
    for(l in 1:length(dataVect)){
      if(cl == as.numeric(clustList[l])){
        clusteredListSeq = append(clusteredListSeq[], dataVect[l])
        clusteredListAct = append(clusteredListAct[], dataVect_var[l])
        clusteredActivityVect = append(clusteredListAct[], dataVect_var[l])
        
      }
    }
    meanList = append(meanList, mean(clusteredListAct))
    write.table(as.data.frame(clusteredListSeq), file = fileNameSeq, sep = "\t", quote = FALSE, col.names = FALSE, row.names = FALSE, append = TRUE)
    write.table(as.data.frame(clusteredListAct), file = fileNameAct, sep = "\t", quote = FALSE, col.names = FALSE, row.names = FALSE, append = TRUE)
    
  }
  
  # Reclassement en fonction des moyennes
  for(r in 1:getNumberOfClass(clustList)){
    indiceToModif = which.min(meanList)
    fileNameSeq = paste("result/resultat_sequences_class",as.character(indiceToModif),".txt", sep = "")
    fileNameAct = paste("result/resultat_activités_class",as.character(indiceToModif),".txt", sep = "")
    fileNameSeqFinal = paste("result/resultat_sequences_classe",as.character(r),".txt", sep = "")
    fileNameActFinal = paste("result/resultat_activites_classe",as.character(r),".txt", sep = "")
    file.rename(fileNameSeq, fileNameSeqFinal)
    file.rename(fileNameAct, fileNameActFinal)
    meanList[indiceToModif] = NA
    
  }
  }
  
  # Affichage de la table de résultats
  classif = matrix(0, nrow = getNumberOfClass(clustList), ncol=getNumberOfClass(clustList))
  clusteredTheory = clustOfTest(getNbSeqInClass(sort(clustList)))
  clustListNumeric = as.numeric(clustList)
  
  for(i in 1:length(clustList)){
    classif[clustListNumeric[i],clusteredTheory[i]] = classif[clustListNumeric[i],clusteredTheory[i]]+1
  }
  return(classif)
  
}

# obtention de la précision d'une matrice de confusion
runAccuracy = function(matriceDeClassification){
  return((sum(diag(matriceDeClassification))/sum(matriceDeClassification))*100)
}
