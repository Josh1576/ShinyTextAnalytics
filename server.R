if (!require(udpipe)){install.packages("udpipe")}
if (!require(textrank)){install.packages("textrank")}
if (!require(lattice)){install.packages("lattice")}
if (!require(igraph)){install.packages("igraph")}


options(shiny.maxRequestSize = 30*1024^2)

shinyServer(function(input, output) {
  
  Dataset <- reactive({
    
    readfile = input$file1
    if (is.null(readfile$datapath)) { return(NULL) } else
    {
      
      require(stringr)
      #Data <- readLines(readfile$datapath)
      Data <- readtext(readfile$datapath, encoding = "UTF-8")
      Data  =  str_replace_all(Data, "<.*?>", "")
      return(Data)
      
    }
  })    
  
  annotate_model <- reactive({
    model_lang = udpipe_load_model(input$file2$datapath)
    txt <- as.character(Dataset())
    x <- udpipe_annotate(model_lang, x = txt)
    x <- as.data.frame(x)
    return(x)
  
  })

# Calc and render plot    
#output$plot1 = renderPlot({ 
  
    #data.pca <- prcomp(Dataset(), center = TRUE, scale. = TRUE)
    #plot(data.pca, type = "l"); abline(h=1)    
  
     #  })



output$annotateModel <- renderDataTable({
    if (is.null(input$file2)) {   # locate 'file2' from ui.R
      
      return(NULL) } else{
        
        all_nouns = annotate_model() %>% subset(., upos %in% input$checkGroup) 
        top_nouns = txt_freq(all_nouns$lemma)  # txt_freq() calcs noun freqs in desc order
   #     head(top_nouns, 10) 
        return(annotate_model())
      }
    })    
  

output$Cooccurence <- renderPlot({
  if (is.null(input$file2)) {   # locate 'file2' from ui.R
    
    return(NULL) } 
  
  else{
      cooccurence_data <- cooccurrence(x = subset(annotate_model(), upos %in% input$checkGroup), term = "lemma", 
                                      group = c("doc_id", "paragraph_id", "sentence_id")) # 0.02 secs
      
      #str(cooccurence_data)
      #head(nokia_cooc)
      
     wordnetwork <- head(cooccurence_data, 50)
      
      #wordnetwork <- cooccurence_data
      wordnetwork <- igraph::graph_from_data_frame(wordnetwork) # needs edgelist in first 2 colms.
      
      ggraph(wordnetwork, layout = "fr") +  
        
        geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
        geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
        
        theme_graph(base_family = "Arial Narrow") +  
        theme(legend.position = "none") +
        
        labs(title = "Cooccurrences within 3 words distance")
      
      #return(all_nouns)
    }
})    


  
})
