########################################################
###  Algorithme de calcul de distances personnalisé  ###
########################################################

# C'est ici que vous pourrez implémenter votre propre algorithme de calcul de distance.

# l'algorithme doit prendre en entrée deux vecteurs contenant des caractères unitaires (exemple: c("A","T","G","C"))
# et doit retourner une variable de type numérique (entier; flottant; ...).
# C'est cette dernière qui représentera la distance entre vos deux séquences.

algoDistCustom = function(vect1, vect2){
  
  # Implémentez votre algorithme ici...
  
  

}



## Exemple avec l'algorithme de Levenshtein (à copier-coller dans la fonction "algoDistCustom" en retirant les commentaires devant les instructions)

#matrice = matrix(0, nrow = length(vect1)+1, ncol = length(vect2)+1)
#for(i in 1:length(vect1)){
#  matrice[i+1,1] = i
#}
#for(j in 1:length(vect2)){
#  matrice[1,j+1] = j
#}
#for(i in 1:length(vect1)){
#  for(j in 1:length(vect2)){
#    if (vect1[i] == vect2[j]){
#      subcost = 0
#    }else{
#      subcost = 1
#    }
#    matrice[i+1,j+1] = min(matrice[i+1,j]+1, matrice[i,j+1]+1, matrice[i,j]+subcost)
#  }
#}
#return(matrice[length(vect1)+1, length(vect2)+1])

## Fin de l'exemple