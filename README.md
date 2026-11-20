# ZnCPT

R Shiny app from the Chouchani Lab for exploring zinc-dependent cysteine reactivity, with 3D protein structures (Mol*).

## Files
- `app.R` - the Shiny app
- `*.csv` - data read at startup
- `Logo_ZnCPT.png`, `thumbnail_Cysteine_accessibility.png` - images

## Run locally
```r
install.packages(c("shiny","DT","shinyjs","glue","shinydashboard","png","plotly","ggplot2","dplyr","base64enc","htmltools","remotes"))
remotes::install_github("Appsilon/shiny.molstar")
shiny::runApp()
```