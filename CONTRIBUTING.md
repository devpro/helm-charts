# Contributing

## File organization

## Repository Structure

`/charts` contains the source of custom Helm charts.

> [!NOTE]
> [Helm Chart Releaser](https://github.com/helm/chart-releaser) doesn't support multiple chart directories ou multiple levels so all charts must be in `charts` repository.

`/docs` provides the source of the website, with in particular instructions for:

- Installing popular applications (`/docs/application-guides`)
- Using custom charts (`/docs/custom-charts`)

## Custom Helm charts

### Check manifest during creation

Lint the chart:

```bash
helm lint
```

Generate the Kubernetes manifest yaml:

```bash
helm template myapp . -f values.yaml --namespace myns > temp.yaml
```

### Deploy from sources

Install the application:

```bash
helm upgrade --install myapp . -f values.yaml --namespace myns --create-namespace --debug > output.yaml
```

### Run locally CI checks

Lint charts with [helm/chart-testing](https://github.com/helm/chart-testing) (with workaround described at [issue #464](https://github.com/helm/chart-testing/issues/464)):

```bash
docker run --rm -it --workdir=/data --volume $(pwd):/data quay.io/helmpack/chart-testing:v3.13.0 \
  /bin/sh -c "git config --global --add safe.directory /data ; ./scripts/add_helm_repo.sh ; ct lint --target-branch main"
```

> [!TIP]
> Beware if you're on Windows, as some files may be with the EOL CRLF and could be seen as a difference needing a version bump.
> You can find them with `find charts/ -type f -exec file {} \; | grep CLRF`, update the EOL (change save from VS Code), and also check on the repo with `git show main:charts/nfs-ganesha/.helmignore | od -c`.

Lint charts with [KubeLinter](https://docs.kubelinter.io/):

```bash
docker run --rm -v $(pwd)/charts:/charts -v $(pwd)/.kube-linter.yaml:/etc/config.yaml stackrox/kube-linter \
  lint /charts --config /etc/config.yaml
```

### View Chart repository references

- [aws/eks-charts](https://github.com/aws/eks-charts)
- [rancher/helm3-charts](https://github.com/rancher/helm3-charts)

## Documentation website

The website is built with [VitePress](https://vitepress.dev/) and:

- plugins: [VitePress Sidebar](https://github.com/jooy2/vitepress-sidebar)
- theme: [Catppuccin for VitePress](https://github.com/catppuccin/vitepress)

The project was generated using `npx vitepress init`.

Run locally the website with:

```bash
npm run docs:dev
```
