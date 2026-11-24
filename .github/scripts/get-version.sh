#!/usr/bin/env bash
cd "$(dirname "${0}")/../.."
repo_name="$(basename "$(git rev-parse --show-toplevel)")"
repo_url="$(git remote get-url origin || echo "none")"
echo "Repository: ${repo_name}" >&2
echo "- Path: $(pwd)" >&2
echo "- Url: ${repo_url}" >&2
last_version=$(git tag -l '[0-9]*.[0-9]*.[0-9]*' | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | sort -V | tail -n 1)
if [ -z "${last_version}" ]; then
  last_version="0.1.0"
  echo "WARNING: A version tag not found, use a default one: ${last_version}" >&2
else
  echo "Found last version tage: ${last_version}" >&2
  IFS='.' read -r major minor patch <<< "${last_version}"
fi
echo "Current version:" >&2
echo "${last_version}" 2>&1
