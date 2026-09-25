# AGENTS.md

Guidance for coding agents working in this repository.

## What this is

A collection of Helm charts published as a chart repository at `https://devpro.github.io/helm-charts`, alongside a VitePress documentation site.
Charts cover both custom applications maintained by devpro and third-party applications packaged for convenience.

## Repository layout

- **`charts/`**: the source of every chart, one directory per chart.
  [Helm Chart Releaser](https://github.com/helm/chart-releaser) supports neither multiple chart directories nor nested levels, so every chart lives directly under `charts/` and nowhere else.
- **`docs/`**: the VitePress site, with application guides in `docs/application-guides` and custom chart documentation in `docs/custom-charts`.
- **`samples/`**: example manifests and values.
- **`scripts/`**: helper scripts, including `add_helm_repo.sh` which adds the dependency repositories the charts need.

## Common commands

```bash
helm lint charts/<chart>                                                  # lint one chart
helm template myapp charts/<chart> -f values.yaml --namespace myns        # render the manifests
helm upgrade --install myapp charts/<chart> -f values.yaml --namespace myns --create-namespace
kube-linter lint charts --config .kube-linter.yaml                        # the check CI runs
npm run docs:dev                                                          # serve the documentation site
```

## Releasing a chart

A chart is published when its `version` in `Chart.yaml` changes on `main`, so a change to any chart file needs a version bump in the same commit or nothing is released.
`version` is the chart's own version and `appVersion` is the version of the packaged application: they move independently.
Where a chart pins an image tag in `values.yaml`, that tag and `appVersion` must be updated together.

## Conventions

- Chart values are documented with `# --` comments above the key, which is the helm-docs annotation form.
- A chart that packages a devpro application keeps its values structure close to the application's configuration keys, so that a setting can be traced from `values.yaml` to the environment variable it becomes.
- CI runs `kube-linter` over `charts/` with `.kube-linter.yaml`, and `ct lint` over the charts changed against `main`.
  Exclusions belong in `.kube-linter.yaml` with a comment saying why.
- Markdown and YAML are linted in CI through `.markdownlint-cli2.yaml` and `.yamllint.yaml`.
- Do not run markdownlint: linting is run manually by the maintainer and in CI.
- Files carrying real values for a local deployment are named `values.mine.yaml` and are gitignored, so they are never edited or committed.

## Writing style

These rules apply to Markdown, YAML comments, chart templates, code comments, commit messages, and any prose in scripts.

**One sentence per line.**
A line break only ever happens at the end of a sentence, and a sentence is never wrapped across two lines.
There is no maximum line length: screens are wide, and the 80 character convention is not used here.
This applies to comments as much as to prose, so a long comment sentence stays on a single line rather than continuing onto a second comment line.
Wrapping is handled by the editor, not by hard newlines.

**Never use the em dash (`—`) or the en dash (`–`).**
Use a colon when introducing an explanation, a comma when joining clauses, or a full stop and a new sentence.
This applies to prose, code comments, table cells, and error message strings.

**Never use the second person.**
No "you", no "your", not even in placeholders such as `<your-token>`, which should read `<token>`.
The documentation describes the repository, it does not address a reader.
Write "the working tree", not "your working tree".

**Other conventions.**
Use `ini` as the fence language for `.properties` blocks, never `properties`.
Prefer `>` over `→` when describing UI navigation, for example **Project Settings > Quality Gate**.

Existing files predate these rules and break them in places.
That is not a reason to add more, and not a reason to reformat prose that a change does not otherwise touch.

### Scripts

Shell scripts are named in `snake_case`, which is the standard for bash: `add_helm_repo.sh`, not `add-helm-repo.sh`.

Scripts must be committed with the executable bit set.
A script committed as `100644` fails on a fresh clone even though it works locally:

```bash
git update-index --chmod=+x path/to/script.sh
```

### Target platform

Target platform is Linux with Docker, including WSL2, and `bash`.
