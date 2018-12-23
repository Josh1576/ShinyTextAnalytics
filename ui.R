#---------------------------------------------------------------------#
#               UDPipe NLP workflow App                               #
#---------------------------------------------------------------------#


library("shiny")

shinyUI(
  fluidPage(
  
    titlePanel("UDPipe NLP workflow"),
  
    sidebarLayout( 
      
      
      sidebarPanel(  
        
        
              fileInput("file1", "Upload text file in any language like hindi, english, spanish etc."),
              
              fileInput("file2", "Upload trained udpipe model (same language as text file)"),
              
              checkboxGroupInput("checkGroup", 
                                        h4("Choose xpos required"), 
                                        choices = list("adjective" = 'ADJ', 
                                                       "noun" = 'NOUN', 
                                                       "proper noun" = 'PROPN',
                                                       "adverb" = 'ADV',
                                                       "verb" = 'VERB'),
                                        selected = c("ADJ","NOUN","PROPN"))
              
                                          ),   # end of sidebar panel
    
    
      
    mainPanel(
      
      tabsetPanel(type = "tabs",
                  
                      tabPanel("Overview",
                               h4(p("Data input")),
                               p("This app supports only text data file.",align="justify"),
                               p("Please refer to the link below for sample csv file."),
                               a(href="https://raw.githubusercontent.com/sudhir-voleti/sample-data-sets/master/text%20analysis%20data/amazon%20nokia%20lumia%20reviews.txt"
                                 ,"Sample data input file"),   
                               br(),
                               h4('How to use this App'),
                               p('To use this app, click on', 
                                 span(strong("Upload text file of any language like hindi, english, spanish etc.")),
                                 'and upload the text file. You can also choose the options for POS. ',
                                  span(strong("Please ensure to upload text file of any language like hindi, english, spanish etc."))
                                 ),
                               p("Please refer to the link below for udpipe file."),
                               a(href="https://github.com/bnosac/udpipe.models.ud/tree/master/models" 
                                 , "Udpipe files")  
                               ),
                      tabPanel("Co-occurences Plot", 
                                   plotOutput('Cooccurence')), 
                      
                      tabPanel("Annotate Document",
                               dataTableOutput('annotateModel'))
                      
        
      ) # end of tabsetPanel
          )# end of main panel
            ) # end of sidebarLayout
              )  # end if fluidPage
                ) # end of UI
  


