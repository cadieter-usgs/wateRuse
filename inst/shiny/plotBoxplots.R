plotBoxplots <- reactive({
  
  w.use <- w.use()
  
  data.elements <- c(df[["data.element"]],df[["data.element.y"]])
  
  validate(
    need(input$state, 'Choose a State'),
    need(input$area, 'Choose an Area')
  )
  
  areas.p2e <- df[["area"]]
  
  if(all(df[["areas"]] %in% areas.p2e)){
    areas.p2e <- NA
  }
  notch <- input$notchOn
  yrs <- NA # may want to code ability to select certain years
  log <- input$log
  
  area.column <- df[["area.column"]]

  w.use <- filter(w.use, YEAR %in% input$whatYears)
  
  plotBoxplots <- boxplot_wu(w.use, data.elements, area.column, areas=areas.p2e, 
                             plot.notch=notch, years=yrs, log=log)
  
  write.csv(x = plotBoxplots$data, file="plotBoxplots.csv", row.names = FALSE)
  
  plotBoxplots
  
})

output$plotBoxplots <- renderPlot({
  plotBoxplots()
})

output$downloadPlotBoxplots <- downloadHandler(
  filename = function() { "plotBoxplots.png" },
  content = function(file) {
    ggsave(file, plot = plotBoxplots(), device = "png")
  }
)

output$downloadPlotBoxplotsPDF <- downloadHandler(
  filename = function() { "plotBoxplots.pdf" },
  content = function(file) {
    ggsave(file, plot = plotBoxplots(), device = "pdf")
  }
)

output$downloadPlotBoxplotsData <- downloadHandler(
  filename = function() { "plotBoxplots.csv" },
  content = function(file) {
    file.copy("plotBoxplots.csv", file)
  }
)

output$plotBoxplotsCode <- renderPrint({
  
  data.elem <- c(df[["data.element"]],df[["data.element.y"]])
  areas.pTC <- df[["areas"]]

  areasOptions <-  df[["areas"]]
  
  if(all(areasOptions %in% areas.pTC)){
    areas.pTC <- NA
  } else {
    areas.pTC <- paste0('c("',paste(areas.pTC, collapse = '","'),'")')
  }
  
  area.column <- df[["area.column"]]
  notch <- input$notchOn
  yrs <- NA #to be changed when code added for year selection
  log <- input$log
  
  outText <- paste0(
    'data.elements <- c("',paste0(data.elem,collapse = '","'),'")\n',
    "areas <- ",areas.pTC, "\n",
    'area.column <- "', area.column, '"\n',
    'notch <- ',notch,"\n",
    'yrs <- ', yrs,"\n",
    'log <- ',log,"\n",
    "boxplot_wu(w.use, data.elements, area.column, areas=areas.p2e,\n", 
    "plot.notch=notch, years=yrs, log=log)"
    
  )
  
  HTML(outText)
  
})