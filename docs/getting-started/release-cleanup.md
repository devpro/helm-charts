# Release cleanup

## Why

Every chart version published on `main` becomes a GitHub release, a tag and an entry of `index.yaml` on the `gh-pages` branch.
Nothing ever removes them, so the chart repository keeps offering old versions, and versions of charts removed from `charts/`.
`scripts/delete_old_releases.sh` keeps only the latest version of each chart in `charts/`, and removes everything else.

## Requirements

- `git`, `curl`, `jq` and `helm` on the `PATH`.
- A clone of the repository whose `origin` can push to `devpro/helm-charts`.
- A GitHub token in `GITHUB_TOKEN`, allowed to write the repository contents:
  a fine-grained token on `devpro/helm-charts` with **Contents: Read and write**, or a classic token with the `repo` scope.

## Usage

List the tags whose release would be deleted, without changing anything:

```bash
scripts/delete_old_releases.sh
```

Delete them:

```bash
GITHUB_TOKEN=<token> scripts/delete_old_releases.sh --apply
```

Delete given tags only, instead of the computed list:

```bash
GITHUB_TOKEN=<token> scripts/delete_old_releases.sh --apply cow-demo-0.2.3 sidelab-0.1.6
```

With `--apply`, the script:

1. Deletes the GitHub release of each tag, before the tag, as a release can no longer be found by a deleted tag.
2. Deletes the tags with `git push origin --delete`, and prunes them from the clone.
3. Builds `index.yaml` again from the packages of the releases left, and pushes it to `gh-pages`.

The site serves the new index once the `PKG` workflow runs again, on the next push to `main` or by hand from the Actions tab.

## Immutable releases

GitHub never lets the tag of an immutable release be created again, even once the release and the tag are deleted.
It does no harm for an old version, which is never published again, and the script says which tags it blocked.
A version to publish again is never deleted while its release is immutable: it is published under a new version only, by bumping `version` in its `Chart.yaml`.

The immutable releases are listed with:

```bash
curl -s "https://api.github.com/repos/devpro/helm-charts/releases?per_page=100" | jq -r '.[] | "\(.tag_name)\timmutable=\(.immutable)"'
```
