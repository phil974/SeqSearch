#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

# Import de librairies
library(shiny)

#import des fichiers sources
source("main.R")
source("main2.R")



# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  # Exécution de l'auto apprentissage en appuyant sur le premier bouton
  observeEvent(input$runAlgo, {
    
    fsb = as.vector(read.table(input$fichierSequencesBrut$datapath)[,1])
    fab = as.vector(read.table(input$fichierActivitesBrut$datapath)[,1])
    md = input$mode
    algorthm = input$algo
    reac = input$nombreClassesHCPC
    if(reac == 1){
      nombreDeClasses = -1
    }else if(reac == 2){
      nombreDeClasses = 0
    }else{
      nombreDeClasses = input$num
    }
    showGraph = FALSE
    createFiles = input$createF
  
    res = runAlgo(fsb, fab, md, algorthm, showGraph, nombreDeClasses, createFiles)
    
    output$matriceResultat <- renderTable(res)
    output$precision <- renderText(paste("Précision: ",runAccuracy(res),"%"))
    
  })
  
  # Exécution de la fonction de "rangement" des séquences en appuyant sur le deuxième bouton
  observeEvent(input$runAlgo2, {
  
    seq = as.vector(read.table(input$fichierNewSeqBrut$datapath)[,1])
    md = input$mode
    algorthm = input$algo
    
    inpt = runAlgo2(seq, md, algorthm)
    
    output$matriceResultat = renderTable(inpt)
    output$precision = renderText("")
    
  })
  
})
