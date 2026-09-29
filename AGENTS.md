# helm-charts: agent context

## What this is

A collection of Helm charts published as a chart repository at `https://devpro.github.io/helm-charts`, alongside a VitePress documentation site.
Charts cover both custom applications maintained by devpro and third-party applications packaged for convenience.

Target platform is Linux with Docker, including WSL2, and `bash`.

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

## Working rules

- **Every command runs in the foreground, and the agent waits for it.**
  No background commands, no subagents, no forks, no parallel tasks, even for a long commands.
- Headers stay: short documentation still has sections.
- Commit only when asked, and never push.
  Shell scripts are `snake_case` and committed with the executable bit (`git update-index --chmod=+x`).
- Documentation is as short as possible.

## Writing style

Applies to Markdown, code comments, commit messages and prose in scripts.

- **A comment says why, not what, and the why is timeless.**
- **One thought per line.**
  Every sentence starts on its own line, and there is no maximum line length.
- **No em dash, no en dash.**
  A colon, a comma, or a full stop.
- **No second person.**
  "The working tree", not "your working tree"; `<token>`, not `<your-token>`.
