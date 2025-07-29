# Contributing

## File organization

## Repository Structure

`/charts` contains custom Helm charts.

> [!NOTE]
> [Helm Chart Releaser](https://github.com/helm/chart-releaser) doesn't support multiple chart directories ou multiple levels so all charts must be in `charts` repository.

`/docs` provides instructions for:

- Installing popular applications (`/docs/application-guides`)
- Using custom charts (`/docs/custom-charts`)

## Chart edition

### Check manifest before installation

Lint the chart:

```bash
helm lint
```

Generate the Kubernetes manifest yaml:

```bash
helm template nfs-ganesha . -f values.yaml --namespace nfs-ganesha > temp.yaml
```

### Check installation

Install the application:

```bash
helm upgrade --install nfs-ganesha . -f values.yaml --namespace nfs-ganesha --create-namespace --debug > output.yaml
```

### Validate the code

Lint charts with [helm/chart-testing](https://github.com/helm/chart-testing) (with workaround described at [issue #464](https://github.com/helm/chart-testing/issues/464)):

```bash
docker run --rm -it --workdir=/data --volume $(pwd):/data quay.io/helmpack/chart-testing:v3.13.0 \
  /bin/sh -c "git config --global --add safe.directory /data ; ./scripts/add_helm_repo.sh ; ct lint --target-branch main"
```

Beware if you're on Windows, as some files may be with the EOL CRLF.
You can find them with `find charts/ -type f -exec file {} \; | grep CLRF`, update the EOL (change save from VS Code), and also check on the repo with `git show main:charts/nfs-ganesha/.helmignore | od -c`.

Lint charts with [KubeLinter](https://docs.kubelinter.io/):

```bash
docker run --rm -v $(pwd)/charts:/charts -v $(pwd)/.kube-linter.yaml:/etc/config.yaml stackrox/kube-linter \
  lint /charts --config /etc/config.yaml
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
