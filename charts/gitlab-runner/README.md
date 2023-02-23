# GitLab Runner

This Helm chart will install [GitLab Runners](https://docs.gitlab.com/runner/) and is based from the [official Helm chart](https://gitlab.com/gitlab-org/charts/gitlab-runner) ([docs](https://docs.gitlab.com/runner/install/kubernetes.html)).

## How to update the chart

```bash
# adds helm chart repository
helm repo add gitlab https://charts.gitlab.io/
helm repo update

# searches for the latest version
helm search repo -l gitlab-runner

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update
```

## How to deploy manually

```bash
# gets ingress controller public IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# optional: checks the Kubernetes objects generated from the chart
helm template gitlab-runner . -f values.yaml \
  --namespace supply-chain > temp.yaml

# manual: grab registration token in GitLab > <group_name> > Runners > Register a group runner

# creates helm release to have ubuntu/docker runners
helm upgrade --install gitlab-runner-ubuntu-docker . -f values.yaml \
  --set gitlab-runner.gitlabUrl=https://gitlab.${NGINX_PUBLIC_IP}.sslip.io/ \
  --set gitlab-runner.runnerRegistrationToken=**** \
  --set gitlab-runner.runners.executor=kubernetes \
  --set gitlab-runner.runners.tags="docker" \
  --set gitlab-runner.runners.name="Ubuntu Docker image" \
  --namespace supply-chain

# docker executor doesn't seem to work even with privileged set to true (can be checked by looking at the /configmaps/config.template.toml file)
# from GitLab run: ERROR: Failed to remove network for build ERROR: Preparation failed: Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running? (docker.go:739:0s)

# checks everything is ok
kubectl get all -n supply-chain

# if needed, deletes the chart
helm uninstall gitlab-runner-ubuntu-docker -n supply-chain
```

## How to investigate

### Known limitations

* This Helm chart doesn't work with replicas different to 1 so multiple Helm releases from the same chart is needed
