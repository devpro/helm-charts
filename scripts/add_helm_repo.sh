#!/bin/bash

helm repo add argo                  https://argoproj.github.io/argo-helm
helm repo add azuredisk-csi-driver  https://raw.githubusercontent.com/kubernetes-sigs/azuredisk-csi-driver/master/charts
helm repo add bitnami               https://charts.bitnami.com/bitnami
helm repo add blob-csi-driver       https://raw.githubusercontent.com/kubernetes-sigs/blob-csi-driver/master/charts
helm repo add gitlab                https://charts.gitlab.io/
helm repo add ingress-nginx         https://kubernetes.github.io/ingress-nginx
helm repo add harbor                https://helm.goharbor.io
helm repo add jetstack              https://charts.jetstack.io
helm repo add neuvector             https://neuvector.github.io/neuvector-helm/
helm repo add sealed-secrets        https://bitnami-labs.github.io/sealed-secrets
helm repo add sonarqube             https://sonarsource.github.io/helm-chart-sonarqube
