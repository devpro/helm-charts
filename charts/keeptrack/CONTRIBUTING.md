# Contributing guide

## Update chart dependencies

1. Add Bitnami chart repository:

    ```bash
    helm repo add bitnami https://charts.bitnami.com/bitnami
    helm repo update
    ```

2. Search for the latest version:

    ```bash
    helm search repo -l bitnami/mongodb --versions
    ```

3. Edit manually `Chart.yaml` with the new version

4. Update `Chart.lock`:

    ```bash
    helm dependency update
    ```
