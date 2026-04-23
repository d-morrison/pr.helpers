with_git_repo <- function(code) {
  repo <- withr::local_tempdir()
  withr::local_dir(repo)

  system2("git", c("init", "-b", "main"), stdout = TRUE, stderr = TRUE)
  system2(
    "git",
    c("config", "user.name", "Test User"),
    stdout = TRUE,
    stderr = TRUE
  )
  system2(
    "git",
    c("config", "user.email", "test@example.com"),
    stdout = TRUE,
    stderr = TRUE
  )

  writeLines("hello", "README.md")
  system2("git", c("add", "README.md"), stdout = TRUE, stderr = TRUE)
  system2("git", c("commit", "-m", "init"), stdout = TRUE, stderr = TRUE)

  force(code)
}

test_that("pr_request_url builds GitHub URL for HTTPS remotes", {
  remote_url <- "https://github.com/acme/widgets.git"
  url <- pr_request_url(
    remote_url,
    source_branch = "feature/issue-123",
    target_branch = "main"
  )

  expect_equal(
    url,
    paste0(
      "https://github.com/acme/widgets/compare/",
      "main...feature%2Fissue-123?expand=1"
    )
  )
})

test_that("pr_request_url builds GitLab URL for SSH remotes", {
  url <- pr_request_url(
    "git@gitlab.com:acme/widgets.git",
    source_branch = "feature/issue-123",
    target_branch = "develop"
  )

  expect_equal(
    url,
    paste0(
      "https://gitlab.com/acme/widgets/-/merge_requests/new?",
      "merge_request%5Bsource_branch%5D=feature%2Fissue-123&",
      "merge_request%5Btarget_branch%5D=develop"
    )
  )
})

test_that("pr_request_url errors for unsupported remotes", {
  expect_error(
    pr_request_url(
      "https://example.com/acme/widgets.git",
      source_branch = "feature/issue-123",
      target_branch = "main"
    ),
    "Unsupported remote host"
  )
})

test_that("pr_init creates branch and pr_resume switches back", {
  with_git_repo({
    pr_init("feature/test-pr")
    expect_equal(
      system("git branch --show-current", intern = TRUE),
      "feature/test-pr"
    )

    system2("git", c("checkout", "main"), stdout = TRUE, stderr = TRUE)
    pr_resume("feature/test-pr")
    expect_equal(
      system("git branch --show-current", intern = TRUE),
      "feature/test-pr"
    )
  })
})

test_that("pr_view(number) builds provider-specific URL", {
  with_git_repo({
    system2(
      "git",
      c("remote", "add", "origin", "https://github.com/acme/widgets.git"),
      stdout = TRUE,
      stderr = TRUE
    )
    expect_equal(
      pr_view(number = 12, target = "primary"),
      "https://github.com/acme/widgets/pull/12"
    )

    system2(
      "git",
      c("remote", "set-url", "origin", "git@gitlab.com:acme/widgets.git"),
      stdout = TRUE,
      stderr = TRUE
    )
    expect_equal(
      pr_view(number = 34, target = "primary"),
      "https://gitlab.com/acme/widgets/-/merge_requests/34"
    )
  })
})
