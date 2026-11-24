#!/usr/bin/env bash
cd "$(dirname "${0}")/../.."
repo_name="$(basename "$(git rev-parse --show-toplevel)")"
repo_url="$(git remote get-url origin || echo "none")"
branch="${GITHUB_HEAD_REF:-"${GITHUB_REF_NAME:-"$(git branch --show-current)"}"}"
echo "Repository: ${repo_name}" >&2
echo "- Path: $(pwd)" >&2
echo "- Url: ${repo_url}" >&2
echo "- Branch: ${branch}" >&2

last_version=$(./.github/scripts/get-version.sh)
next_version=
IFS='.' read -r major minor patch release <<< "${last_version}"
if [[ "${branch}" == "master" || "${1}" == "--release" ]]; then
  next_version="${major}.${minor}.$((patch + 1))"
else
  next_version="${major}.${minor}.${patch}.$(date +%s)"
fi

echo "Previous version:" >&2
echo "${last_version:-"0.0.0"}" >&2
echo "Next version:" >&2
echo "${next_version}" 2>&1
