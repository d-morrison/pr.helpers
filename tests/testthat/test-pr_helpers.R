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
