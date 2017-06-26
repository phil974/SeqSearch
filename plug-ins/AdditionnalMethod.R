
# Fonction de conversion des séquences sous forme de chaine de caractères en séquence sous forme de vecteur.
# Cette fonction vise à faciliter la manipulation des séquences lors de l'utilisation d'algorithme de distance.
seqToVect = function(seq){
  res = c("")
  for(i in 1:nchar(seq)){
    res[i] = substr(seq,start=i,stop=i)
  }
  return(res)
}

# Fonction permettant d'obtenir le nombre de classes après exécution de l'HCPC.
# NB: classList doit être sous forme de vecteur contenant uniquement la 1ere colonne de $data.clust
getNumberOfClass = function(classList){
  a = as.numeric(classList)
  res = max(a)
  return(res)
}

# Fonction permettant d'obtenir un vecteur contenant le nombre d'éléments dans chaque classes
getNbSeqInClass = function(hcpcVector){
  res = c()
  for(iRun in 1:getNumberOfClass(hcpcVector)){
    counter = 0
    for(jRun in 1:length(hcpcVector)){
      if(iRun == hcpcVector[jRun]){
        counter = counter+1
      }
    }
    res = append(res, counter)
  }
  return(res)
}
