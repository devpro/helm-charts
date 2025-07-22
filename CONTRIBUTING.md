# Contribution guide

## Validate a change

* Lint charts with [helm/chart-testing](https://github.com/helm/chart-testing)

```bash
# runs in a container (with workaround described at https://github.com/helm/chart-testing/issues/464)
docker run --rm -it --workdir=/data --volume $(pwd):/data quay.io/helmpack/chart-testing:v3.7.1 /bin/sh -c "git config --global --add safe.directory /data ; ./scripts/add_helm_repo.sh ; ct lint --target-branch main"
```

* (not yet available because of [Issue #575](https://github.com/stackrox/kube-linter/issues/575)) Lint charts with [stackrox/kube-linter](https://github.com/stackrox/kube-linter) ([docs](https://docs.kubelinter.io/))

```bash
# runs in a container
docker run --rm -v $(pwd)/charts:/charts -v $(pwd)/.kube-linter.yaml:/etc/config.yaml stackrox/kube-linter lint /charts --config /etc/config.yaml
```

## References

* Cloud Native components
  * [Cloud Native Interactive Landscape](https://landscape.cncf.io/)
* Documentation
  * [Rancher How-to Guides > Helm Charts > Creating Apps](https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/helm-charts-in-rancher/create-apps)
* Examples
  * [argoproj/argocd-example-apps](https://github.com/argoproj/argocd-example-apps)
  * [helm/charts](https://github.com/helm/charts)
  * [rancher/rodeo](https://github.com/rancher/rodeo)
* Official repositories
  * [argoproj/argo-helm](https://github.com/argoproj/argo-helm)
  * [aws/eks-charts](https://github.com/aws/eks-charts)
  * [bitnami/charts](https://github.com/bitnami/charts)
  * [elastic/helm-charts](https://github.com/elastic/helm-charts)
  * [grafana/helm-charts](https://github.com/grafana/helm-charts)
  * [prometheus-community/helm-charts](https://github.com/prometheus-community/helm-charts)
  * [rancher/charts](https://github.com/rancher/charts)
  * [rancher/helm3-charts](https://github.com/rancher/helm3-charts)
