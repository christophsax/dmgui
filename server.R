shinyServer(function(input, output) {

# data and filters -------------------------------------------------------------

  r_dm <- reactive({
    dm <- dm_nycflights13()
    dm
  })

  # table selector -------------------------------------------------------------

  r_data_table <- reactive({
    dm <- r_dm()
    data <- data_table(dm)
    data
  })

  output$o_table <- renderReactable({
    data <- r_data_table()
    reactable_table(data)
  })

  r_table_names <- reactive({
    n <- getReactableState("o_table", "selected")
    req(r_data_table())[n, ] |> pull(name)
  })

  # so we can use conditionalPanel() and avoid renderUI for now
  output$is_table_selected <- reactive({
    length(r_table_names()) > 0
  })
  outputOptions(output, "is_table_selected", suspendWhenHidden = FALSE)

  # table mode (1 table selected) ----------------------------------------------

  r_data_column <- reactive({
    table_name <- r_table_names()
    if (length(table_name) != 1) return(NULL)

    dm <- r_dm()
    data <- data_column(dm, table_name)
    data
  })

  output$o_column <- renderReactable({
    data <- req(r_data_column())
    reactable_column(data)
  })

  r_column_names <- reactive({
    n <- getReactableState("o_column", "selected")
    req(r_data_column())[n, ] |> pull(name)
  })

  # so we can use conditionalPanel() and avoid renderUI for now
  output$is_column_selected <- reactive({
    length(r_column_names()) > 0
  })
  outputOptions(output, "is_column_selected", suspendWhenHidden = FALSE)

  # calls to middleware --------------------------------------------------------

  # update a reactive r_obs in each step

  observeEvent(input$i_rm_tbl, {
    showNotification(paste0("Hey middleware: remove table(s) from dm: ", toString(r_table_names())))
  })

  observeEvent(input$i_add_pk, {
    showNotification(paste("Hey middleware: add column(s) ",toString(r_column_names()) ," as primary key to table: ", r_table_names()))
  })


  # output ---------------------------------------------------------------------

  output$o_draw <- renderGrViz({
      dm <- r_dm()
      dm_draw(dm)
  })

})
