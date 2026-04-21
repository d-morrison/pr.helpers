#' Build a pull/merge request URL from a git remote
#'
#' @param remote_url A git remote URL.
#' @param source_branch The source branch name.
#' @param target_branch The target branch name.
#'
#' @return A URL string that can be used to open a new pull request (GitHub) or
#'   merge request (GitLab).
#' @export
#'
#' @examples
#' pr_request_url(
#'   "https://github.com/OWNER/REPO.git",
#'   source_branch = "feature/new-thing",
#'   target_branch = "main"
#' )
pr_request_url <- function(remote_url, source_branch, target_branch) {
  remote <- parse_remote_url(remote_url)

  if (remote$provider == "github") {
    return(sprintf(
      "https://%s/%s/compare/%s...%s?expand=1",
      remote$host,
      remote$repo,
      utils::URLencode(target_branch, reserved = TRUE),
      utils::URLencode(source_branch, reserved = TRUE)
    ))
  }

  if (remote$provider == "gitlab") {
    return(sprintf(
      paste0(
        "https://%s/%s/-/merge_requests/new?",
        "merge_request%%5Bsource_branch%%5D=%s&",
        "merge_request%%5Btarget_branch%%5D=%s"
      ),
      remote$host,
      remote$repo,
      utils::URLencode(source_branch, reserved = TRUE),
      utils::URLencode(target_branch, reserved = TRUE)
    ))
  }

  cli::cli_abort("Unsupported remote host: {.val {remote$host}}.")
}

parse_remote_url <- function(remote_url) {
  remote_url <- trimws(remote_url)

  if (grepl("^[^@]+@[^:]+:.+$", remote_url)) {
    remote_url <- sub("^([^@]+)@([^:]+):(.+)$", "ssh://\\1@\\2/\\3", remote_url)
  }

  parts <- tryCatch(
    utils::URLdecode(remote_url),
    error = function(...) remote_url
  )

  match <- regexec(
    "^(?:[a-zA-Z][a-zA-Z0-9+.-]*://)?(?:[^@/]+@)?([^/:]+)(?::[0-9]+)?/(.+)$",
    parts
  )
  captures <- regmatches(parts, match)[[1]]

  if (length(captures) != 3) {
    cli::cli_abort("Could not parse remote URL: {.val {remote_url}}.")
  }

  host <- tolower(captures[2])
  repo <- sub("\\.git$", "", captures[3])
  repo <- sub("^/+", "", repo)

  provider <- if (grepl("(^|\\.)github\\.", host)) {
    "github"
  } else if (grepl("(^|\\.)gitlab\\.", host)) {
    "gitlab"
  } else {
    "unknown"
  }

  list(provider = provider, host = host, repo = repo)
}
