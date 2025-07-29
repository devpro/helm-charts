#!/bin/bash

helm repo add azuredisk-csi-driver  https://raw.githubusercontent.com/kubernetes-sigs/azuredisk-csi-driver/master/charts
helm repo add bitnami               https://charts.bitnami.com/bitnami
helm repo add blob-csi-driver       https://raw.githubusercontent.com/kubernetes-sigs/blob-csi-driver/master/charts
helm repo add gitlab                https://charts.gitlab.io/
helm repo add grafana               https://grafana.github.io/helm-charts
helm repo add hobbyfarm             https://hobbyfarm.github.io/hobbyfarm
helm repo add minio                 https://charts.min.io/
helm repo add mongodb               https://mongodb.github.io/helm-charts
helm repo update
