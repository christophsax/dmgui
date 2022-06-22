shinyUI(dashboardPage(
  dashboardHeader(title = "dm GUI"),
  dashboardSidebar(
    collapsed = TRUE
  ),
  dashboardBody(
    tags$head(
      tags$link(href = "docs.css", rel = "stylesheet")
    ),
    fluidRow(
      box(
        title = "Tables",
        status = "primary",
        width = 3,
        reactableOutput('o_table')
      ),
      box(
        title = "DM",
        status = "primary",
        width = 6,
        grVizOutput('o_draw')
      ),
      box(
        title = "Sidebar",
        status = "primary",
        width = 3,
        conditionalPanel(condition = "output.is_table_selected",
          actionButton("i_rm_tbl", "Delete table")
        ),
        reactableOutput('o_column'),
        conditionalPanel(condition = "output.is_column_selected",
          actionButton("i_add_pk", "Add primary key")
        )
      )
    )
  )
))
