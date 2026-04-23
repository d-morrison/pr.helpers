#' Helpers for pull/merge request workflows
#'
#' @description
#' The `pr_*()` family helps with common pull request (GitHub) and merge request
#' (GitLab) workflows from a local Git repository.
#'
#' These helpers are inspired by the `usethis::pr_*()` family and adapted for
#' this package's GitHub/GitLab support.
#'
#' @details
#' Adapted from pull request helper concepts in the usethis package:
#' <https://github.com/r-lib/usethis/blob/main/R/pr.R> (MIT License).
#'
#' @name pull-requests
NULL

#' @export
#' @rdname pull-requests
#' @param branch Name of a branch.
pr_init <- function(branch) {
  check_branch_name(branch)

  if (git_branch_exists(branch)) {
    cli::cli_inform(c(
      "i" = "Branch {.val {branch}} already exists; switching to it."
    ))
    return(pr_resume(branch))
  }

  git_run(c("checkout", "-b", branch))
  cli::cli_inform(c("v" = "Created and switched to {.val {branch}}."))
  invisible(branch)
}

#' @export
#' @rdname pull-requests
pr_resume <- function(branch = NULL) {
  if (is.null(branch)) {
    default_branch <- git_default_branch()
    branches <- git_local_branches()
    branches <- branches[branches != default_branch]
    if (length(branches) == 0) {
      cli::cli_abort("No non-default local branch is available to resume.")
    }
    branch <- branches[[1]]
  }

  check_branch_name(branch)
  if (!git_branch_exists(branch)) {
    cli::cli_abort("Branch {.val {branch}} does not exist.")
  }

  git_run(c("checkout", branch))
  tracking <- git_tracking_branch(branch)
  if (!is.na(tracking)) {
    git_run(c("pull", "--ff-only"))
  }

  cli::cli_inform(c("v" = "Switched to {.val {branch}}."))
  invisible(branch)
}

#' @export
#' @rdname pull-requests
#' @param number Pull/merge request number.
#' @param target Which remote should be treated as the destination repository?
#'   Use `"source"` (defaults to `upstream` when present, otherwise `origin`) or
#'   `"primary"` (always `origin`).
pr_fetch <- function(number, target = c("source", "primary")) {
  target <- match.arg(target)
  if (missing(number) || is.null(number) || length(number) != 1) {
    cli::cli_abort("`number` must be supplied for `pr_fetch()`.")
  }

  remote <- resolve_target_remote(target)
  remote_url <- git_remote_url(remote)
  provider <- parse_remote_url(remote_url)$provider
  local_branch <- paste0("pr-", as.integer(number))

  fetch_ref <- switch(
    provider,
    github = sprintf("pull/%s/head", number),
    gitlab = sprintf("merge-requests/%s/head", number),
    cli::cli_abort(
      "Unsupported remote host: {.val {parse_remote_url(remote_url)$host}}."
    )
  )

  git_run(c("fetch", remote, fetch_ref))
  git_run(c("branch", "-f", local_branch, "FETCH_HEAD"))
  git_run(c("checkout", local_branch))

  cli::cli_inform(c(
    "v" = paste0(
      "Fetched {.val {provider}} request #{number} ",
      "to local branch {.val {local_branch}}."
    )
  ))
  invisible(local_branch)
}

#' @export
#' @rdname pull-requests
pr_push <- function() {
  branch <- git_current_branch()
  default_branch <- git_default_branch()
  if (branch == default_branch) {
    cli::cli_abort(
      "Create/switch to a non-default branch before calling `pr_push()`."
    )
  }

  tracking <- git_tracking_branch(branch)
  remote <- if (!is.na(tracking)) sub("/.*$", "", tracking) else "origin"

  if (is.na(tracking)) {
    git_run(c("push", "-u", remote, branch))
  } else {
    git_run(c("push"))
  }

  remote_url <- git_remote_url(remote)
  url <- pr_request_url(
    remote_url,
    source_branch = branch,
    target_branch = default_branch
  )
  maybe_browse_url(url)

  cli::cli_inform(c(
    "v" = "Pushed {.val {branch}}.",
    "i" = "Create/view request: {.url {url}}"
  ))
  invisible(url)
}

#' @export
#' @rdname pull-requests
pr_pull <- function() {
  git_run(c("pull", "--ff-only"))
  invisible(TRUE)
}

#' @export
#' @rdname pull-requests
pr_merge_main <- function(target = c("source", "primary")) {
  target <- match.arg(target)
  remote <- resolve_target_remote(target)
  default_branch <- git_default_branch(remote)

  git_run(c("fetch", remote, default_branch))
  git_run(c("merge", "--no-edit", sprintf("%s/%s", remote, default_branch)))
  invisible(TRUE)
}

#' @export
#' @rdname pull-requests
pr_view <- function(number = NULL, target = c("source", "primary")) {
  target <- match.arg(target)
  remote <- resolve_target_remote(target)
  remote_url <- git_remote_url(remote)

  url <- if (is.null(number)) {
    branch <- git_current_branch()
    default_branch <- git_default_branch(remote)
    if (branch == default_branch) {
      cli::cli_abort(
        "On the default branch. Supply `number` to view an existing request."
      )
    }
    pr_request_url(
      remote_url,
      source_branch = branch,
      target_branch = default_branch
    )
  } else {
    pr_number_url(remote_url, number)
  }

  maybe_browse_url(url)
  invisible(url)
}

#' @export
#' @rdname pull-requests
pr_pause <- function(target = c("source", "primary")) {
  target <- match.arg(target)
  remote <- resolve_target_remote(target)
  default_branch <- git_default_branch(remote)

  if (git_current_branch() != default_branch) {
    git_run(c("checkout", default_branch))
  }
  git_run(c("pull", "--ff-only", remote, default_branch))

  cli::cli_inform(c(
    "v" = "Now on {.val {default_branch}} and synced from {.val {remote}}."
  ))
  invisible(default_branch)
}

#' @export
#' @rdname pull-requests
pr_finish <- function(number = NULL, target = c("source", "primary")) {
  target <- match.arg(target)
  remote <- resolve_target_remote(target)
  default_branch <- git_default_branch(remote)

  branch <- if (is.null(number)) {
    git_current_branch()
  } else {
    paste0("pr-", as.integer(number))
  }
  if (branch == default_branch) {
    cli::cli_abort(
      "`pr_finish()` must be called from (or given) a non-default branch."
    )
  }
  if (!git_branch_exists(branch)) {
    cli::cli_abort("Branch {.val {branch}} does not exist.")
  }

  if (git_current_branch() == branch) {
    git_run(c("checkout", default_branch))
  }
  git_run(c("pull", "--ff-only", remote, default_branch))
  git_run(c("branch", "-D", branch))

  cli::cli_inform(c("v" = "Deleted local branch {.val {branch}}."))
  invisible(default_branch)
}

#' @export
#' @rdname pull-requests
pr_forget <- function() {
  pr_finish()
}

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

pr_number_url <- function(remote_url, number) {
  remote <- parse_remote_url(remote_url)

  if (remote$provider == "github") {
    return(sprintf(
      "https://%s/%s/pull/%s",
      remote$host,
      remote$repo,
      as.integer(number)
    ))
  }

  if (remote$provider == "gitlab") {
    return(sprintf(
      "https://%s/%s/-/merge_requests/%s",
      remote$host,
      remote$repo,
      as.integer(number)
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

check_branch_name <- function(branch) {
  if (
    !is.character(branch) ||
      length(branch) != 1 ||
      is.na(branch) ||
      !nzchar(branch)
  ) {
    cli::cli_abort("`branch` must be a single non-empty string.")
  }
}

git_run <- function(args) {
  out <- system2("git", args = args, stdout = TRUE, stderr = TRUE)
  status <- attr(out, "status")

  if (!is.null(status) && status != 0) {
    msg <- paste(
      c(sprintf("git %s", paste(args, collapse = " ")), out),
      collapse = "\n"
    )
    cli::cli_abort(msg)
  }

  out
}

git_current_branch <- function() {
  git_run(c("rev-parse", "--abbrev-ref", "HEAD"))[[1]]
}

git_branch_exists <- function(branch) {
  length(git_run(c("branch", "--list", branch))) > 0
}

git_local_branches <- function() {
  out <- git_run(c("branch", "--format", "%(refname:short)"))
  out[nzchar(out)]
}

git_tracking_branch <- function(branch = git_current_branch()) {
  out <- suppressWarnings(system2(
    "git",
    args = c(
      "rev-parse",
      "--abbrev-ref",
      "--symbolic-full-name",
      sprintf("%s@{upstream}", branch)
    ),
    stdout = TRUE,
    stderr = TRUE
  ))
  status <- attr(out, "status")
  if (!is.null(status) && status != 0) {
    return(NA_character_)
  }
  out[[1]]
}

git_remote_url <- function(remote) {
  git_run(c("remote", "get-url", remote))[[1]]
}

git_remote_exists <- function(remote) {
  remote %in% git_run("remote")
}

resolve_target_remote <- function(target = c("source", "primary")) {
  target <- match.arg(target)

  remote <- if (target == "source" && git_remote_exists("upstream")) {
    "upstream"
  } else {
    "origin"
  }

  if (!git_remote_exists(remote)) {
    cli::cli_abort("Remote {.val {remote}} is not configured.")
  }

  remote
}

git_default_branch <- function(remote = "origin") {
  out <- system2(
    "git",
    args = c(
      "symbolic-ref",
      "--quiet",
      "--short",
      sprintf("refs/remotes/%s/HEAD", remote)
    ),
    stdout = TRUE,
    stderr = TRUE
  )
  status <- attr(out, "status")

  if (is.null(status) || status == 0) {
    return(sub(sprintf("^%s/", remote), "", out[[1]]))
  }

  show_out <- git_run(c("remote", "show", remote))
  line <- grep("HEAD branch:", show_out, value = TRUE)
  if (length(line) > 0) {
    return(trimws(sub(".*HEAD branch:\\s*", "", line[[1]])))
  }

  "main"
}

maybe_browse_url <- function(url) {
  if (interactive()) {
    utils::browseURL(url)
  } else {
    cli::cli_inform(c("i" = "Open this URL manually: {.url {url}}"))
  }
}
