library(shiny)
library(DT)
library(shinyjs)
library(shiny.molstar)
library(glue)
library(shinydashboard)
library(png)
library(plotly)
library(ggplot2)
library(dplyr)
library(base64enc)
library(htmltools)

# Set the working directory
#setwd('/Users/shelleywei/Partners HealthCare Dropbox/ECLab/Chouchani Lab/Data/Shelley/Zinc Website/zinc_revision_sep_2024')

download1 <- read.csv('zinc_website_data_rounded2.csv')
download2 <- read.csv('zinc_protein_sequence_data_updated2.csv')
download3 <- read.csv('Zinc.csv')
download4 <- read.csv('TPEN.csv')
download5 <- read.csv('EDTA_1mM.csv')
download6 <- read.csv('EDTA_5mM.csv')
download7 <- read.csv("Zinc_Prostate.csv")
download8 <- read.csv("TPEN_Prostate.csv")
download9 <- read.csv("Zinc_Hepatocytes.csv")
#colnames(download9)[7] <- "p"
download10 <- read.csv("TPEN_Hepatocytes.csv")
data_og <- read.csv('zinc_website_data_rounded2.csv')
sequence_data <- read.csv('zinc_protein_sequence_data_updated2.csv')  # Load the second data file

## revision data

data_pros <- read.csv("zinc_website_data_pros2.csv")
#data_pros <- data_pros[, -1]
data_hep <- read.csv("zinc_website_data_hep2.csv")
#data_hep <- data_hep[, -1]

img_path <- "Logo_ZnCPT.png"
img_base64 <- base64encode(img_path)


# UI
ui <- dashboardPage(
  dashboardHeader(
    title = "ZnCPT"
  ),
  dashboardSidebar(
    tags$head(
      tags$style(HTML(paste0("
        .main-header .logo {
          margin: 0;
          padding: 0;
          text-align: center;
          font-weight: bold;
          font-size: 24px; /* Modify font size */
          background: url('data:image/png;base64,", img_base64, "') no-repeat 47px 13px; /* Horizontal: 10px, Vertical: 20px */
          background-size: 38px 25px; /* Increase length */
          padding-left: 50px; /* Adjust this value based on your logo size */
        }
      ")))
    ),
    sidebarMenu(
      menuItem("Home", tabName = "home"),
      menuItem("Help", tabName = "help"),
      menuItem("Search", tabName = "search"),
      menuItem("Download", tabName = "download"),
      menuItem("Acknowledgements", tabName = "acknowledgements"),
      menuItem("Copyright and License Information", tabName = "copyright"),
      menuItem(" "),
      tags$div(
        tags$a(
          href = "https://pubmed.ncbi.nlm.nih.gov",
          icon("link"),
          "PUBMED",
          style = "color: #008b8b; text-decoration: none; font-size: 12px; margin: 2px 0 2px 20px;",  # Added margin-left: 10px;
          target = "_blank"
        )
      ),  
      tags$div(
        tags$a(
          href = "https://www.uniprot.org",
          icon("link"),
          "UNIPROT",
          style = "color: #008b8b; text-decoration: none; font-size: 12px; margin: 2px 0 2px 20px;",  # Added margin-left: 10px;
          target = "_blank"
        )
      ),  
      tags$div(
        tags$a(
          href = "https://zincbind.net",
          icon("link"),
          "ZincBind",
          style = "color: #008b8b; text-decoration: none; font-size: 12px; margin: 2px 0 2px 20px;",  # Added margin-left: 10px;
          target = "_blank"
        )
      ),
      tags$div(
        tags$a(
          href = "https://www.ebi.ac.uk/interpro/",
          icon("link"),
          "InterPro",
          style = "color: #008b8b; text-decoration: none; font-size: 12px; margin: 2px 0 2px 20px;",  # Added margin-left: 10px;
          target = "_blank"
        )
      ),
      tags$div(
        tags$a(
          href = "https://alphafold.ebi.ac.uk",
          icon("link"),
          "AlphaFold",
          style = "color: #008b8b; text-decoration: none; font-size: 12px; margin: 2px 0 2px 20px;",  # Added margin-left: 10px;
          target = "_blank"
        ) 
      )
    )
  ),
  dashboardBody(
    tags$head(
      tags$style(HTML('
        body, .skin-blue .content-wrapper, .right-side {
          background-color: #f9fafc !important;
        }
        .sidebar-menu, .main-sidebar {
          background-color: #222d32 !important;
        }
        .content-wrapper, .main-sidebar {
          overflow-y: scroll !important;
          max-height: calc(1vh - 80px) !important; /* Adjust the max-height value as needed */
        }
        .sidebar {
          overflow-y: auto !important;
        }
      '))
    ),
    tabItems(
      tabItem(
        tabName = "home",
        h2(HTML("Welcome to <span style='color: #008b8b;'>ZnCPT</span> – The Human Zinc Binding Cysteine Proteome Database!")),
        p(HTML("Zinc is an essential micronutrient that regulates a wide range of physiological processes, principally through Zn<sup>2+</sup> binding to protein cysteine residues. Despite being critical for modulation of protein function, for the vast majority of the human proteome the cysteine sites subject to Zn<sup>2+</sup> binding remain undefined. Here we develop ZnCPT, a comprehensive and quantitative mapping of the zinc binding cysteine proteome. We define thousands of zinc binding protein cysteines, uncovering protein families across major domains of biology that are subject to either constitutive or inducible modification by zinc. ZnCPT enables systematic discovery of zinc binding structural, enzymatic, and allosteric functional domains. We provide ZnCPT as a resource for understanding mechanisms of zinc regulation of protein function. ZnCPT determines the zinc binding status across HCT116 cells, as well as primary human hepatocytes and prostate epithelial cells.")),
        imageOutput("logo"),
        p(HTML("Please Cite: <strong>Burger et al. (2025) Cell.; doi: <a href='https://doi.org/10.1016/j.cell.2024.11.025'>https://doi.org/10.1016/j.cell.2024.11.025</a></strong>"))
      ),
      tabItem(
        tabName = "help",
        h2("Background"),
        p(HTML("Zinc is an essential micronutrient that regulates a wide range of physiological processes, principally through Zn<sup>2+</sup> binding to protein cysteine residues. Despite being critical for modulation of protein function, for the vast majority of the human proteome the cysteine sites subject to Zn<sup>2+</sup> binding remain undefined. Here we develop ZnCPT, a comprehensive and quantitative mapping of the zinc binding cysteine proteome. We define thousands of zinc binding protein cysteines, uncovering protein families across major domains of biology that are subject to either constitutive or inducible modification by zinc. ZnCPT enables systematic discovery of zinc binding structural, enzymatic, and allosteric functional domains. We provide ZnCPT as a resource for understanding mechanisms of zinc regulation of protein function. ZnCPT determines the zinc binding status across HCT116 cells, as well as primary human hepatocytes and prostate epithelial cells.")),
        p(""),
        h2("Guide to exploring ZnCPT"),
        tags$ul(
          tags$li("Select the cell type in which you would like to explore zinc binding to your favorite protein"),
          tags$li("Add the UniProt Name, Gene Name or UniProt ID of your favorite protein into the search query box and select the appropriate category under search for"),
          tags$li("If your protein is not found, likely it was not mapped in the selected dataset. Please ensure you have entered the correct name or ID"),
          tags$li("The average ratio of labeled cysteines compared to the untreated control (level of accessibility) is provided. Statistical significance between control and treatment is shown."),
          tags$li("Under the structure tab quantified cysteines can be explored on a primary sequence and structural level."),
          tags$li("Cysteine data for individual proteins can be downloaded from the search window."),
          tags$li("The entire dataset can be downloaded from the “Download” window.")
        ),
        p("Note the cysteine site numbers indicate the cysteine(s) that were labeled for a given peptide."),
        p("The ZnCPT web application was developed by Shelley Wei (Chouchani Lab, DFCI) and Nils Burger (Chouchani Lab, DFCI/HMS)."),
        p(HTML("Please Cite: <strong>Burger et al. (2025) Cell.; doi: <a href='https://doi.org/10.1016/j.cell.2024.11.025'>https://doi.org/10.1016/j.cell.2024.11.025</a></strong>"))
      ),
      tabItem(
        tabName = "search",
        h2("Enter your search query:"),
        p("The ZnCPT dataset was done in HCT116 cells, primary human prostate epithelial cells, and primary human hepatocytes. Use the toggle function to choose the cell line you want to search in."),
        fluidRow(
          column(
            width = 3,
            selectInput("cell_type", "Choose a Cell Line:", c("HCT116", "Prostate", "Hepatocytes"), selected = "HCT116", multiple = FALSE),
            selectizeInput("search_query", "Enter your search query:", choices = NULL, multiple = FALSE),
            selectInput("search_type", "Search for:", c("Protein Name", "Uniprot", "Gene"), selected = "Protein Name"), # Set default
            actionButton("search_button", "Search"),
            verbatimTextOutput("search_result")
          ),
          column(
            width = 9,
            # Use img() for a static image, or imageOutput() if you want it to be dynamic
            imageOutput("image")
          )
        ),
        mainPanel(
          # Use conditionalPanel to display the conditional tabs only when the button is clicked
          conditionalPanel(
            condition = "input.search_button > 0",
            conditionalPanel(
              downloadButton("download_search_results", "Download Search Results (csv)"),
              condition = "output.dataExists == true",
              tabsetPanel(
                id = "tabs",
                tabPanel(
                  "Table",
                  tags$div(
                    id = "continuous-scroll-content",
                    style = "overflow-y: scroll; overflow-x: scroll; height: 3000px; width: 1000px; position: relative; margin-top: 20px;",  # Set the desired height,
                    div(
                      id = "1",
                      h2("TPEN Treatment"),
                      DTOutput("table_tab_content_tpen")
                    ),
                    div(
                      id = "2",
                      h2(HTML("ZnCl<sub>2</sub> Treatment")),
                      DTOutput("table_tab_content_zinc")
                    ),
                    div(id = "3",
                        uiOutput("conditional_ui")
                    )
                  )
                ),  
                tabPanel(
                  "Structure",
                  tags$div(
                    id = "continuous-scroll-content",
                    style = "overflow-y: scroll; height: 1300px;",  # Set the desired height,
                    div(
                      id = "section1",
                      h2("2D Sequence Structure"),
                      p(plotlyOutput("sequence_plot"))
                    ),
                    div(
                      id = "section4",
                      h2("Protein Sequence")
                    ),
                    div(
                      id = "section5",
                      p(box(
                        width = 12,
                        solidHeader = TRUE,
                        background = "light-blue",
                        uiOutput("seq")
                      ))
                    ),
                    div(
                      id = "section2",
                      h2("3D Alphafold Structure"),
                      # Display the UniProt ID dynamically
                    ),
                    div(
                      id = "section3",
                      uiOutput("alpha")
                    )
                  )
                )
              )
            ),
            conditionalPanel(
              condition = "output.dataExists == false",
              p("Search query does not exist in dataset. Please recheck your search and enter a valid query.")
            )
          )
          
        )
      ),
      tabItem(
        tabName = "download",
        h2("Bulk Download Data Files"),
        # Add a download button in the "Downloads" tab
        p("Download flat files (comma-separated) containing all data displayed in the ZnCPT website."),
        p(" "),
        p("Download cysteine accessibility data:"),
        downloadButton("download_btn_1", "Download All HCT Cysteine Data (csv)"),
        downloadButton("download_btn_11", "Download All Prostate Cysteine Data (csv)"),
        downloadButton("download_btn_12", "Download All Hepatocytes Cysteine Data (csv)"),
        downloadButton("download_btn_2", "Download Protein Sequences (csv)"),
        p(" "),
        p("Individual datasets:"),
        downloadButton("download_btn_3", "Download HCT Zinc Data (csv)"),
        downloadButton("download_btn_4", "Download HCT TPEN Data (csv)"),
        downloadButton("download_btn_5", "Download HCT EDTA 1mM Data (csv)"),
        downloadButton("download_btn_6", "Download HCT EDTA 5mM Data (csv)"),
        p(" "),
        downloadButton("download_btn_7", "Download Prostate Zinc Data (csv)"),
        downloadButton("download_btn_8", "Download Prostate TPEN Data (csv)"),
        p(" "),
        downloadButton("download_btn_9", "Download Hepatocytes Zinc Data (csv)"),
        downloadButton("download_btn_10", "Download Hepatocytes TPEN Data (csv)")
      ),
      tabItem(
        tabName = "acknowledgements",
        h2("Acknowledgements"),
        p("The ZnCPT website uses the following tools/frameworks/libraries:"),
        p("• Shiny: ", a("https://shiny.posit.co", href = "https://shiny.posit.co")),
        p("• AlphaFold: ", a("https://alphafold.ebi.ac.uk", href = "https://alphafold.ebi.ac.uk"))
      ),
      tabItem(
        tabName = "copyright",
        h2("Copyright and License Information"),
        p("The ZnCPT website was developed and is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License."),
        p("Images presented and generated on the ZnCPT website are licensed under the Creative Commons Attribution-ShareAlike 4.0 International License.")
      )
    )
  ),
  skin = "black",
)


server <- function(input, output, session) {
  output$logo <- renderImage({
    list(src="Logo_ZnCPT.png", width=270, height=180)
  },
  
  deleteFile = FALSE)
  
  output$image <- renderImage({
    list(src="thumbnail_Cysteine_accessibility.png", width=545, height=250)
  },
  
  deleteFile = FALSE)
  # Create a reactive value to store the selected row
  selectedRow <- reactiveVal(NULL)
  filtered_data <- reactiveVal()
  data <- reactiveVal()
  type <- reactiveVal()
  #result_dict <- reactiveVal(list())
  #sequence_length <- reactiveVal(NULL)
  #sequence_match <- reactiveVal()
  #unique_values <- reactiveVal()
  
  #dataExists <- reactiveVal()
  
  observeEvent(input$cell_type, {
    if (input$cell_type == "Hepatocytes") {
      data(data_hep)
    } else if (input$cell_type == "Prostate") {
      data(data_pros)
      type("pros")
    } else {
      data(data_og)
    }
  })
  
  
  # Create a list of unique values for autocomplete suggestions
  autocomplete_choices <- reactive({
    column_to_search <- switch(input$search_type,
                               "Protein Name" = "Protein_Name",
                               "Uniprot" = "Uniprot",
                               "Gene" = "Gene"
    )
    unique(data()[[column_to_search]])
  })
  
  observe({
    updateSelectizeInput(session, "search_query", choices = autocomplete_choices())
  })
  
  observeEvent(input$search_button, {
    search_query <- tolower(input$search_query)
    search_type <- input$search_type
    
    if (search_type == "Protein Name") {
      column_to_search <- "Protein_Name"
    } else if (search_type == "Uniprot") {
      column_to_search <- "Uniprot"
    } else if (search_type == "Gene") {
      column_to_search <- "Gene"
    } else {
      column_to_search <- NULL
    }
    if (!is.null(column_to_search)) {
      # Update the filtered_data reactiveVal with the filtered data
      filtered_data(data()[tolower(data()[[column_to_search]]) == search_query, ])# Make column values lowercase for comparison
      filter <- filtered_data()
      filter <- na.omit(filter)
      filtered_data(filter)
    }
  })
  
  output$dataExists <- reactive({
    nrow(filtered_data()) > 0
  })
  
  outputOptions(output, "dataExists", suspendWhenHidden = FALSE)
  
  output$conditional_ui <- renderUI({
    if (input$cell_type == "HCT116") {
      tagList(
        h2("EDTA Treatment (1 and 5 mM)"),
        DTOutput("table_tab_content_edta")
      )
    }
  })
  
  output$table_tab_content_tpen <- renderDT({
    filtered_data_value <- filtered_data() %>%
      filter(grepl("TPEN", Condition))
    
    if (!is.null(filtered_data_value)) {
      datatable(filtered_data_value, options = list(pageLength = 10, dom = 'tip', autoWidth = TRUE, scrollX = TRUE, searchBox = list('width' = '150px')), rownames = FALSE)
    }
  })
  output$table_tab_content_zinc <- renderDT({
    filtered_data_value <- filtered_data() %>%
      filter(grepl("ZnCl|Zinc", Condition))
    
    if (!is.null(filtered_data_value)) {
      datatable(filtered_data_value, options = list(pageLength = 10, dom = 'tip', autoWidth = TRUE, scrollX = TRUE, searchBox = list('width' = '150px')), rownames = FALSE)
    }
  })
  output$table_tab_content_edta <- renderDT({
    filtered_data_value <- filtered_data() %>%
      filter(grepl("EDTA", Condition))
    
    if (!is.null(filtered_data_value)) {
      datatable(filtered_data_value, options = list(pageLength = 10, dom = 'tip', autoWidth = TRUE, scrollX = TRUE, searchBox = list('width' = '150px')), rownames = FALSE)
    }
  })
  
  observe({
    if(!is.null(filtered_data()) && nrow(filtered_data()) > 0) {
      uni <- filtered_data()[1, 3]
      # Search for the UniProt value in the sequence_data
      sequence_match <- sequence_data[sequence_data$Uniprot == uni, ]
      
      if (nrow(sequence_match > 0)) {
        
        sequence_length <- nchar(sequence_match$Sequence)
        third_split_values <- sapply(strsplit(filtered_data()[, 1], "_"), function(x) as.character(x[3]))
        
        # Split each third split value by ";" and add each secondary split element to a list
        secondary_split_list <- unlist(strsplit(third_split_values, ";"))
        
        # Take only unique values in the list
        unique_values <- unique(as.numeric(secondary_split_list[secondary_split_list != ""]))
        result_dict <- list()  # Initialize result_dict outside the loop
        for (numeric_value in unique_values) {
          # Function to determine the condition based on numeric value
          determine_conditions <- function(cysteine_site, filtered_data) {
            # Find rows with the cysteine_site value in the first column
            matching_rows <- filtered_data[grep(cysteine_site, filtered_data[, 1]), ]
            
            # Extract values from the last three columns of matching rows
            last_col_values <- matching_rows[, ncol(matching_rows)]
            fourth_to_last_col_values <- matching_rows[, ncol(matching_rows) - 3]
            third_to_last_col_values <- matching_rows[, ncol(matching_rows) - 2]
            if(!is.null(type())){
              val <- "p"
            } else {
              val <- "p_adj"
            }
            
            # Create conditions by concatenating values
            concatenated_values <- paste0(last_col_values, " (", "Ratio: ", fourth_to_last_col_values, " | ", val, ": ", third_to_last_col_values, ")")
            
            # Take unique concatenated values
            conditions <- unique(concatenated_values)
            conditions_with_line_breaks <- paste(conditions, collapse = "\n")
            
            return(conditions_with_line_breaks)
          }
          
          # Call determine_conditions and store the result
          result_dict[[as.character(numeric_value)]] <- determine_conditions(numeric_value, filtered_data())
          previous_numeric_value <- numeric_value
        }
      }
    } 
    
    
    # Render the sequence plot in the "Structure" tab if there is a match
    
    # Render the sequence plot
    output$sequence_plot <- renderPlotly({
      if(nrow(filtered_data()) > 0) {
        # Create a data frame to store the data points
        if (nrow(sequence_match > 0)) {
          df <- data.frame(x = 1:sequence_length, y = rep(1, sequence_length), label = rep("", sequence_length))
          # Iterate over the unique values and set the label at those positions
          for (val in unique_values) {
            df$val[df$x == val] <- "Cys"
          }
          
          # Define the text to be displayed on hover
          hover_text <- sapply(unique_values, function(cys_site) {
            conditions_with_line_breaks <- result_dict[[as.character(cys_site)]]
            paste("Conditions:", paste(conditions_with_line_breaks, collapse = ", "))
          })
          
          cysteine_plot <- data.frame(Residue = unique_values, y = rep(0.5, length(unique_values)))
          
          # Plot the data
          p <- ggplot(df, aes(x = x, y = y)) +
            geom_line(aes(color = label), size = 3) +
            scale_color_manual(values = c("#222222", "red")) +
            theme_minimal() +
            labs(x = NULL, y = NULL, title = "Protein Sequence") +  # Remove x and y labels
            theme(axis.title.y = element_blank(),
                  axis.text.y = element_blank(),
                  axis.ticks.y = element_blank(),
                  plot.title = element_text(hjust = 2),
                  panel.grid.major.y = element_blank()) +
            geom_point(data = cysteine_plot,
                       aes(x = Residue, y = 1),  # Specify the hover text directly
                       color = "black",  # Set outline color
                       shape = 16,
                       size = 6) +
            geom_point(data = cysteine_plot,
                       aes(x = Residue, y = 1, text = hover_text),  # Specify the hover text directly
                       color = "#008b8b",  # Set outline color
                       shape = 16,
                       size = 5,
                       alpha = 0.8) +
            guides(color = FALSE)  # Remove the color legend
          
          ggplotly(p)
        } else {
          plot(0, type = "n", xlab = "", ylab = "", xlim = c(0, 1), ylim = c(0, 1), axes = FALSE)
          text(0.5, 0.5, "No protein sequence available", cex = 1.2, col = "red", font = 2)
        }
      }
    })
    
    # Return the HTML
    output$seq <- renderUI({
      if(nrow(filtered_data()) > 0) {
        if (nrow(sequence_match > 0)) {
          # Highlight "c"s in the sequence
          protein_sequence <- isolate(sequence_match$Sequence)
          highlighted_sequence <- gsub("(c)", '<span style="color: red;">\\1</span>', protein_sequence, ignore.case = TRUE)
          
          # Define the style for the container div
          container_style <- "max-height: 150px; overflow-y: auto; border: 1px solid #ccc; padding: 10px; word-wrap: break-word;"
          
          # Generate HTML with the highlighted sequence
          seq_html <- HTML(paste0('<div style="', container_style, '">', highlighted_sequence, '</div>'))
          return(seq_html)
        } else {
          # Set seq to NULL if there is no match
          return(NULL)
        }
      }
    })
    
    output$alpha <- renderUI({
      if(nrow(filtered_data()) > 0) {
        if (nrow(sequence_match > 0)) {
          # Extract the unique third column value of the filtered data
          uniProtId <- unique(filtered_data()[, 3])
          AlphaFoldMolstar(uniProtId = uniProtId,
                           dimensions = c(800, 500),
                           showControls = FALSE,
                           showAxes = TRUE,
                           useInterface = TRUE)
        } else {
          return(NULL)
        }
      }
      
    })
  })
  
  output$download_btn_1 <- downloadHandler(
    filename = function() {
      paste("cysteine_data_hct_all.csv", sep = "")
    },
    content = function(file) {
      write.csv(download1, file)
    }
  )
  output$download_btn_2 <- downloadHandler(
    filename = function() {
      paste("protein_sequence_data.csv", sep = "")
    },
    content = function(file) {
      write.csv(download2, file)
    }
  )
  output$download_btn_3 <- downloadHandler(
    filename = function() {
      paste("zinc_hct.csv", sep = "")
    },
    content = function(file) {
      write.csv(download3, file)
    }
  )
  output$download_btn_4 <- downloadHandler(
    filename = function() {
      paste("tpen_hct.csv", sep = "")
    },
    content = function(file) {
      write.csv(download4, file)
    }
  )
  output$download_btn_5 <- downloadHandler(
    filename = function() {
      paste("edta_1mM_hct.csv", sep = "")
    },
    content = function(file) {
      write.csv(download5, file)
    }
  )
  output$download_btn_6 <- downloadHandler(
    filename = function() {
      paste("edta_5mM_hct.csv", sep = "")
    },
    content = function(file) {
      write.csv(download6, file)
    }
  )
  
  output$download_btn_7 <- downloadHandler(
    filename = function() {
      paste("zinc_prostate.csv", sep = "")
    },
    content = function(file) {
      write.csv(download7, file)
    }
  )
  
  output$download_btn_8 <- downloadHandler(
    filename = function() {
      paste("tpen_prostate.csv", sep = "")
    },
    content = function(file) {
      write.csv(download8, file)
    }
  )
  
  output$download_btn_9 <- downloadHandler(
    filename = function() {
      paste("zinc_hepatocyte.csv", sep = "")
    },
    content = function(file) {
      write.csv(download9, file)
    }
  )
  
  output$download_btn_10 <- downloadHandler(
    filename = function() {
      paste("tpen_hepatocyte.csv", sep = "")
    },
    content = function(file) {
      write.csv(download10, file)
    }
  )
  
  output$download_btn_11 <- downloadHandler(
    filename = function() {
      paste("cysteine_data_prostate_all.csv", sep = "")
    },
    content = function(file) {
      write.csv(data_pros, file)
    }
  )
  
  output$download_btn_12 <- downloadHandler(
    filename = function() {
      paste("cysteine_data_hepatocyte_all.csv", sep = "")
    },
    content = function(file) {
      write.csv(data_hep, file)
    }
  )
  
  # New download handler for search results
  output$download_search_results <- downloadHandler(
    filename = function() {
      paste("search_results_", tolower(input$search_query), ".csv", sep = "")
    },
    content = function(file) {
      if (!is.null(filtered_data())) {
        write.csv(filtered_data(), file)
      }
    }
  )
}

# Run the Shiny app
shinyApp(ui = ui, server = server)