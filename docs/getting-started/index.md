---
order: 1
---

# Getting Started

## Setup

### kubectl

[kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl), Kubernetes command-line tool, must be installed.

::: code-group

```bash [Linux (binary)]
# ref. https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-kubectl-binary-with-curl-on-linux
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

:::

### Helm

[Helm](https://helm.sh/), Kubernetes package manager, must be installed.

::: code-group

```bash [Linux (script)]
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

:::

## Content

### Helm Charts

Helm Charts help define, install, and upgrade even the most complex Kubernetes application.
