library(shinythemes)
ui <- fluidPage(theme=shinytheme("superhero"),
                titlePanel("Calculating VaR using Monte Carlo Simulation"),
                navbarPage("VaR Monte Carlo",
                           
                           tabPanel("Data",
                                    sidebarLayout(
                                      sidebarPanel(
                                        fileInput("data","Please input your data ",accept = c("text",".txt"))
                                      ),
                                      mainPanel(
                                        tabsetPanel(type = "pills",id = "navbar",
                                                    tabPanel("Graph",
                                                             plotOutput("tsplot"),
                                                             value="Plot"),
                                                    tabPanel("Data",verbatimTextOutput("descriptive"),verbatimTextOutput("data"),verbatimTextOutput("ret"),value="Data"),
                                                    tabPanel("Normally test",verbatimTextOutput("normality"),value="Normally test")
                                        )	)	)
                           ),
                           tabPanel("Monte Carlo Simulation",
                                    sidebarLayout(
                                      sidebarPanel(
                                        textInput("w","Initial investment"),
                                        textInput("N","Number of simulation"),
                                        actionButton("calculation","Run",class="btn-primary")
                                      ),
                                      mainPanel(
                                        tabsetPanel(type = "pills",id = "navbar",
                                                    tabPanel("Result of Simulation of Monte Carlo",verbatimTextOutput("VAR"),verbatimTextOutput("interpretation"),value="result")
                                        ))))
                ))
