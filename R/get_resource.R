#' Get Open Data resource
#'
#' @param res_id The resource ID as found on \href{https://www.opendata.nhs.scot/}{NHS Open Data platform}
#' @param rows (optional) specify the max number of rows to return
#' use this when testing code to reduce the size of the request
#' it will default to all data
#'
#' @importFrom magrittr %>%
#' @return a [tibble][tibble::tibble-package] with the data
#' @export
#'
#' @examples get_resource(res_id = "a794d603-95ab-4309-8c92-b48970478c14")
get_resource <- function(res_id, rows = NULL) {
  if (!check_res_id(res_id)) {
    stop(glue::glue("The resource ID supplied ('{res_id}') is invalid"))
  }

  # set resource id-s to use
  res_id <- res_id

  # Define the User Agent to be used for the API call
  ua <- opendata_ua()

  if (is.null(rows) || rows > 99999) {
    if (!is.null(rows)) {
      message("Queries for more than 99,999 rows of data will return the full resource.")
    }

    response <- httr::GET(url = ds_dump_url(res_id), user_agent = ua)

    httr::stop_for_status(response)

    stopifnot(httr::http_type(response) == "text/csv")

    data <- httr::content(response, "parsed") %>%
      dplyr::select(-"_id")

    return(data)
  } else {
    query <- list(
      id = res_id,
      limit = rows
    )

    url <- httr::modify_url(ds_search_url(),
                            query = query
    )

    response <- httr::GET(url = url, user_agent = ua)

    httr::stop_for_status(response)

    stopifnot(httr::http_type(response) == "application/json")

    parsed <- httr::content(response, "text") %>%
      jsonlite::fromJSON()

    data <- parsed$result$records %>%
      tibble::as_tibble()

    return(data)
  }
}

#' Open Data user agent
#' @description
#' This is used internally to return a standard useragent
#' Supplying a user agent means requests using the package
#' can be tracked more easily
#'
#' @return a {httr} user_agent string
opendata_ua <- function() {
  httr::user_agent("https://github.com/Public-Health-Scotland/phsmethods")
}


#' Check if a resource ID is valid
#'
#' @description
#' Used to attempt to validate a res_id before submitting it to the API
#'
#' @param res_id a resource ID
#'
#' @return TRUE / FALSE indicating the validity of the res_id
check_res_id <- function(res_id) {
  res_id_regex <- "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$"


  if (!inherits(res_id, "character")) {
    return(FALSE)
  } else if (!grepl(res_id_regex, res_id)) {
    return(FALSE)
  } else {
    return(TRUE)
  }
}

#' Creates the URL for the datastore search end-point
#'
#' @return a url
ds_search_url <- function() {
  httr::modify_url("https://www.opendata.nhs.scot",
                   path = "/api/3/action/datastore_search"
  )
}

#' Creates the URL for the datastore dump end-point
#'
#' @param res_id a resource ID
#' @return a url
ds_dump_url <- function(res_id) {
  httr::modify_url("https://www.opendata.nhs.scot",
                   path = glue::glue("/datastore/dump/{res_id}?bom=true")
  )
}
