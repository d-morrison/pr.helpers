#!/bin/bash
set -euo pipefail

# Script to download workflow logs from the two most recent commits in a PR branch
# This makes logs available to the GitHub Copilot coding agent for debugging

echo "=== Downloading Workflow Logs for Recent Commits ==="

# Check if we're in a PR context
if [[ -z "${GITHUB_HEAD_REF:-}" ]]; then
  echo "Not in a PR context, skipping workflow log download"
  exit 0
fi

# Get the two most recent commits from the PR branch
echo ""
echo "Getting the two most recent commits from PR branch: ${GITHUB_HEAD_REF}"
COMMITS=$(git log --format="%H" -n 2)
echo "Commits to check:"
echo "$COMMITS"

# Create directory for logs
LOG_DIR="${GITHUB_WORKSPACE}/workflow-logs"
mkdir -p "$LOG_DIR"
echo ""
echo "Logs will be saved to: $LOG_DIR"

# For each commit, find and download workflow logs
echo ""
for COMMIT in $COMMITS; do
  echo "--- Processing commit: $COMMIT ---"
  
  # List all workflow runs for this commit
  echo "Searching for workflow runs for commit: $COMMIT"
  RUNS=$(gh run list --commit "$COMMIT" --json databaseId,name,status,conclusion --limit 50 || echo "[]")
  
  # Check if we found any runs
  RUN_COUNT=$(echo "$RUNS" | jq '. | length')
  if [[ "$RUN_COUNT" -eq 0 ]]; then
    echo "No workflow runs found for commit $COMMIT"
    continue
  fi
  
  echo "Found $RUN_COUNT workflow run(s) for commit $COMMIT"
  
  # Download logs for each run
  echo "$RUNS" | jq -c '.[]' | while read -r RUN; do
    RUN_ID=$(echo "$RUN" | jq -r '.databaseId')
    RUN_NAME=$(echo "$RUN" | jq -r '.name')
    RUN_STATUS=$(echo "$RUN" | jq -r '.status')
    RUN_CONCLUSION=$(echo "$RUN" | jq -r '.conclusion // "in_progress"')
    
    # Create a safe filename
    SAFE_NAME=$(echo "$RUN_NAME" | tr ' /' '_')
    LOG_FILE="$LOG_DIR/${COMMIT:0:8}_${RUN_ID}_${SAFE_NAME}.log"
    
    echo "  Downloading logs for run #$RUN_ID ($RUN_NAME) - Status: $RUN_STATUS, Conclusion: $RUN_CONCLUSION"
    
    # Download the log, even if the run is still in progress or failed
    if gh run view "$RUN_ID" --log > "$LOG_FILE" 2>&1; then
      echo "    ✓ Saved to: $LOG_FILE ($(wc -l < "$LOG_FILE") lines)"
    else
      echo "    ⚠ Could not download logs (may not be available yet)"
      rm -f "$LOG_FILE"
    fi
  done
  
  echo ""
done

# Summary
echo "=== Workflow Log Download Complete ==="
LOG_COUNT=$(find "$LOG_DIR" -name "*.log" 2>/dev/null | wc -l)
if [[ "$LOG_COUNT" -gt 0 ]]; then
  echo "Downloaded $LOG_COUNT log file(s):"
  ls -lh "$LOG_DIR"/*.log 2>/dev/null || true
else
  echo "No logs were downloaded (this is normal if no workflows have run yet)"
fi
echo ""
echo "Logs are available in: $LOG_DIR"
echo "The SWE Agent can access these logs for debugging purposes."
