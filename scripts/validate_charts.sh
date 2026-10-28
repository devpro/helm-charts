#!/bin/bash
# Renders each chart and validates the manifests against the Kubernetes API schemas, which catches a wrong apiVersion or a misspelled field that helm lint lets through.
# A chart is rendered once per values file in its ci directory, as ct does, and with its default values when it has none.
# Usage: scripts/validate_charts.sh [chart directory...], every chart under charts when none is given.

set -euo pipefail

kubernetes_version="${KUBERNETES_VERSION:-1.36.5}"
# Custom resources are read from the CRDs catalog, pinned so that a schema change upstream never breaks an unrelated commit.
# A kind it does not hold, such as the Rancher node driver configurations, is counted as skipped rather than failed.
crds_catalog="https://raw.githubusercontent.com/datreeio/CRDs-catalog/501527ab9c40c827144c8f45945b25a023e344ce/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json"

if [[ $# -gt 0 ]]; then
  charts=("$@")
else
  charts=(charts/*/)
fi

failed=()
for chart in "${charts[@]}"; do
  chart="${chart%/}"
  [[ -f "$chart/Chart.yaml" ]] || continue

  if grep -q "^dependencies:" "$chart/Chart.yaml"; then
    helm dependency build "$chart" > /dev/null
  fi

  values_files=("$chart"/ci/*-values.yaml)
  [[ -e "${values_files[0]}" ]] || values_files=("")

  for values_file in "${values_files[@]}"; do
    echo "--- $chart ${values_file:+with $(basename "$values_file")}"
    if ! helm template ci "$chart" ${values_file:+--values "$values_file"} --namespace ci --kube-version "$kubernetes_version" \
      | kubeconform -strict -summary -ignore-missing-schemas -kubernetes-version "$kubernetes_version" \
        -schema-location default -schema-location "$crds_catalog"; then
      failed+=("$chart ${values_file:+($(basename "$values_file"))}")
    fi
  done
done

if [[ ${#failed[@]} -gt 0 ]]; then
  echo "Invalid charts:"
  printf '  %s\n' "${failed[@]}"
  exit 1
fi
