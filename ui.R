#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#


# Import de librairies
library(shiny)
#library("FactoMineR")
#library("stringdist")


#import des plug ins
#source("plug-ins/AdditionnalMethod.R")
#source("plug-ins/pi_levenshtein.R")
source("main.R")
source("main2.R")



# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("SeqSearch"),
  
  sidebarLayout(
    # Les inputs
    sidebarPanel(
      fluidRow(
       
        fileInput("fichierSequencesBrut", label = h3("Jeu de séquences")),
        fileInput("fichierActivitesBrut", label = h3("Jeu d'activités")),
        
        h3("Lancer la classification"),
        actionButton("runAlgo", label = "GO !")
      ),
      fluidRow(
        fileInput("fichierNewSeqBrut", label = h3("Jeu de séquences à rechercher")),
        
        h3("Rechercher la classe"),
        actionButton("runAlgo2", label = "GO !")
      ),
      fluidRow(  
        h3("paramètres"),
        radioButtons('mode', label = h5("types d'algorithme à utiliser"), choices = list("Standart" = "default", "personnalisé" = "custom"), selected = "default"),
        radioButtons('algo', label = h5("algorithme à utiliser"), choices = list("Levenshtein" = "lv","Restricted Damereau-Levenshtein" = "osa","Full Damereau-Levenshtein"="dl","Longuest common substring"="lcs","q-gram"="qgram","Cosine"="cosine","Jaccard" = "jaccard", "Jaro Winkler" = "jw","Soundex encoding"="soundex" )),
        radioButtons("nombreClassesHCPC", label = h5("Mode de création des classes"), choices = list("Auto" = 1, "Manuel graphique" = 2, "Manuel forcé" = 3),selected = 1),
        numericInput("num", label = h5("Nombre de classes"), value = 3),
        checkboxInput("createF", label = "Créer les fichiers classes", value = TRUE)
    
      )
    ),
    
    # Les outputs
    mainPanel(
      tableOutput("matriceResultat"),
      
      fluidRow(
        h2(textOutput("precision"))
        
      )
    )

 
  )
))
