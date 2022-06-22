library(dplyr)
library(tidyr)
library(readr)
library(shiny)
library(shinydashboard)
library(reactable)
library(DiagrammeR)
library(dm)

# table ------------------------------------------------------------------------

data_table <- function(dm) {
  stopifnot(inherits(dm, "dm"))
  data <- tibble(
    name = names(dm),
    info = vapply(dm, \(x) paste(dim(x), collapse = " x "), "", USE.NAMES = FALSE)
  )
  data
}

reactable_table <- function(data) {
  data |>
  reactable(
    columns = list(
      name = colDef(
        cell = function(value, index) {
          info <- div(style = list(float = "right"), span(class = "tag", data[index, "info"][[1]]))
          tagList(value, info)
        }
      ),
      info = colDef(show = FALSE)
    ),
    selection = "multiple",
    onClick = "select",
    theme = dm_theme()
  )

}

# column -----------------------------------------------------------------------

data_column <- function(dm, table_name = "airports") {
  stopifnot(length(table_name) == 1)
  table_colnames <- colnames(dm[[table_name]])
  table_types <- vapply(dm[[table_name]], \(x) class(x)[1], "", USE.NAMES = FALSE) |>
    substr(start = 1, stop = 3)
  tibble(
    name = table_colnames,
    type = table_types
  )
}

reactable_column <- function(data) {
  data |>
  reactable(
    columns = list(
      name = colDef(cell = function(value, index) {
        type <- div(style = list(float = "right"), span(class = "tag", unname(data[index, "type"][[1]])))
        tagList(value, type)
      }),
      type = colDef(show = FALSE)
    ),
    selection = "multiple",
    onClick = "select",
    theme = dm_theme()
  )
}

# theme ------------------------------------------------------------------------

dm_theme <- function() {
  reactableTheme(
    # cellPadding = "10px 8px",
    style = list(
      ".tag" = list(
        padding = "0.125rem 0.25rem",
        color = "#999",
        fontSize = "0.9rem",
        border = "1px solid #777",
        borderRadius = "2px"
      )
    )
  )
}

