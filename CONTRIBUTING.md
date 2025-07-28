# Contributing

## File organization

## Repository Structure

`/charts` contains custom Helm charts.

> [!NOTE]
> [Helm Chart Releaser](https://github.com/helm/chart-releaser) doesn't support multiple chart directories ou multiple levels so all charts must be in `charts` repository.

`/docs` provides instructions for:

- Installing popular applications (`/docs/application-guides`)
- Using custom charts (`/docs/custom-charts`)

## Code validation

Lint charts with [helm/chart-testing](https://github.com/helm/chart-testing) (with workaround described at [issue #464](https://github.com/helm/chart-testing/issues/464)):

```bash
docker run --rm -it --workdir=/data --volume $(pwd):/data quay.io/helmpack/chart-testing:v3.7.1 \
  /bin/sh -c "git config --global --add safe.directory /data ; ./scripts/add_helm_repo.sh ; ct lint --target-branch main"
```

(not yet available because of [Issue #575](https://github.com/stackrox/kube-linter/issues/575)) Lint charts with [stackrox/kube-linter](https://github.com/stackrox/kube-linter) ([docs](https://docs.kubelinter.io/)):

```bash
docker run --rm -v $(pwd)/charts:/charts -v $(pwd)/.kube-linter.yaml:/etc/config.yaml \
  stackrox/kube-linter lint /charts --config /etc/config.yaml
```

## Chart repository references

- [aws/eks-charts](https://github.com/aws/eks-charts)
- [rancher/helm3-charts](https://github.com/rancher/helm3-charts)

## Documentation website

The documentation is built with [VitePress](https://vitepress.dev/) ([code](https://github.com/vuejs/vitepress)):

- plugins: [VitePress Sidebar](https://github.com/jooy2/vitepress-sidebar)
- theme: [Catppuccin for VitePress](https://github.com/catppuccin/vitepress)

It was generated using `npx vitepress init`.

Run locally the website with:

```bash
npm run docs:dev
```
