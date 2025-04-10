#' getMapping
#'
#' Retrieves latest mapping for a given project.
#' Mappings must contain the columns "variable", "unit", "piam_variable",
#' "piam_unit", "piam_factor".
#' Mappings are csv files with semicolon as a separator and no quotation marks
#' around fields, see main README.Rd file
#'
#' @md
#' @author Falk Benke, Oliver Richters
#' @param project name of requested mapping, or file name pointing to a mapping
#' @param requiredColsOnly whether only the mandatory 5 columns are return
#'        set to TRUE if you want to concatenate mappings
#' @importFrom utils read.csv2 packageVersion
#' @importFrom gms chooseFromList
#' @importFrom tidyselect all_of
#' @importFrom dplyr mutate across
#' @examples
#' \dontrun{
#' getMapping("ECEMF")
#' getMapping("/path/to/mapping/file")
#' }
#' @export
getMapping <- function(project = NULL, requiredColsOnly = FALSE) {
  mappings <- mappingNames()
  if (is.null(project)) {
    project <- chooseFromList(names(mappings), type = "mappings",
                              returnBoolean = FALSE, multiple = FALSE)
    if (length(project) == 0) stop("No mapping selected, abort.")
  }
  if (! file.exists(project)) {
    project <- gsub("^mapping_|\\.csv$", "", project)
  }
  filename <- if (project %in% names(mappings)) mappings[project] else project
  if (file.exists(filename)) {
    data <- read.csv2(filename, header = TRUE, sep = ";", na.strings = list(""),
                      strip.white = TRUE, quote = "", comment.char = "#", dec = ".")

    # check if more than one column is found
    if (length(data) == 1) {
      stop(paste0("Failed to read in ", filename, ". Possible reason: source file must be separated by semicolons!"))
    }

    # fail if required columns are missing
    requiredCols <- c("variable", "unit", "piam_variable", "piam_unit", "piam_factor")
    if (!all(requiredCols %in% colnames(data))) {
      stop(paste0("Failed to read in ", filename, ". Required columns not found: ",
                  paste0(setdiff(requiredCols, colnames(data)), collapse = ", ")))
    }

    # to character if columns are empty
    data <- data %>%
      mutate(across(setdiff(colnames(data), c("tier", "piam_factor")), as.character))

    # return data
    if (isTRUE(requiredColsOnly)) {
      return(select(data, all_of(requiredCols)))
    }

    return(data)
  } else {
    stop("Mapping file ", filename, " not found in piamInterfaces@",
         packageVersion("piamInterfaces"), ". Maybe try updating...")
  }
}

#' for backwards compatibility
#' @inheritParams getMapping
#' @export
getTemplate <- function(project = NULL) return(getMapping(project))
