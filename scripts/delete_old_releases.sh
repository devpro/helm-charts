#!/bin/bash
# Deletes the GitHub releases and tags of old chart versions, so that the chart repository only offers the versions still maintained.
# Each chart under charts keeps its latest tag, and a chart removed from charts loses all of its tags.
# The tags to delete are listed, and only deleted with --apply, which then builds the index of the gh-pages branch again; tags given as arguments replace the computed list.
# Usage: GITHUB_TOKEN=<token> scripts/delete_old_releases.sh [--apply] [tag...]

set -euo pipefail

apply=false
if [[ "${1:-}" == "--apply" ]]; then
  apply=true
  shift
fi

repository="devpro/helm-charts"
api="https://api.github.com/repos/${repository}"
cd "$(dirname "${BASH_SOURCE[0]}")/.."

if [[ $# -gt 0 ]]; then
  tags=("$@")
else
  # A tag is <chart>-<version>, and sort -V orders the versions of a chart from the oldest to the latest.
  mapfile -t tags < <(git ls-remote --tags --refs origin | sed 's#.*refs/tags/##' | sort -V | awk '
    {
      chart = $0
      sub(/-[0-9][^-]*$/, "", chart)
      if (chart in latest) print latest[chart]
      latest[chart] = $0
      charts[chart] = 1
    }
    END {
      for (chart in charts) {
        if (system("test -f charts/" chart "/Chart.yaml") != 0) print latest[chart]
      }
    }' | sort)
fi

if [[ ${#tags[@]} -eq 0 ]]; then
  echo "No tag to delete"
  exit 0
fi
printf '%s\n' "${tags[@]}"
echo "${#tags[@]} tags and their releases to delete"
if [[ "$apply" != true ]]; then
  echo "Nothing deleted, run again with --apply to delete them"
  exit 0
fi

: "${GITHUB_TOKEN:?GITHUB_TOKEN must hold a token allowed to write the contents of ${repository}}"
auth=(-H "Authorization: Bearer ${GITHUB_TOKEN}" -H "Accept: application/vnd.github+json")

# The releases go first, as a release whose tag is deleted can no longer be found by its tag.
deleted=()
for tag in "${tags[@]}"; do
  release=$(curl -fsS "${auth[@]}" "${api}/releases/tags/${tag}" 2>/dev/null || true)
  if [[ -z "$release" ]]; then
    echo "${tag}: no release"
    deleted+=("refs/tags/${tag}")
    continue
  fi
  curl -fsS -X DELETE "${auth[@]}" "${api}/releases/$(jq -r '.id' <<< "$release")"
  # GitHub never lets the tag of an immutable release be created again, which only matters for a version to publish again.
  if [[ "$(jq -r '.immutable' <<< "$release")" == true ]]; then
    echo "${tag}: immutable release deleted, its tag name is blocked for good"
  else
    echo "${tag}: release deleted"
  fi
  deleted+=("refs/tags/${tag}")
done

if [[ ${#deleted[@]} -eq 0 ]]; then
  exit 0
fi
git push origin --delete "${deleted[@]}"
git fetch origin --prune --prune-tags

# The index is built again from the packages of the releases left, so that it offers no version whose download is gone.
work=$(mktemp -d)
trap 'git worktree remove --force "${work}/pages" 2>/dev/null || true; rm -rf "$work"' EXIT
for tag in $(git ls-remote --tags --refs origin | sed 's#.*refs/tags/##'); do
  mkdir "${work}/${tag}"
  curl -fsSL -o "${work}/${tag}/${tag}.tgz" "https://github.com/${repository}/releases/download/${tag}/${tag}.tgz"
  merge=()
  if [[ -f "${work}/index.yaml" ]]; then
    merge=(--merge "${work}/index.yaml")
  fi
  helm repo index "${work}/${tag}" --url "https://github.com/${repository}/releases/download/${tag}" "${merge[@]}"
  mv "${work}/${tag}/index.yaml" "${work}/index.yaml"
done
git worktree add --detach "${work}/pages" origin/gh-pages
cp "${work}/index.yaml" "${work}/pages/index.yaml"
git -C "${work}/pages" commit -am "Build the index again from the releases left, once old chart versions are deleted"
git -C "${work}/pages" push origin HEAD:gh-pages
