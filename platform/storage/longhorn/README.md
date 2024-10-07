# Install Longhorn

**Step 1:** Install `open-iscsi` on all the nodes of K8s cluster, and `iscsid` is running on all the nodes:

```bash
sudo apt install open-iscsi
```

**Step 2:** Add `longhorn` repository to helm and update helm for the latest version:

```bash
helm repo add longhorn https://charts.longhorn.io

helm update
```

**Step 3:** Install Longhorn to the `longhorn` namespace:

```bash
helm install longhorn --namespace longhorn --create-namespace longhorn/longhorn
```

# Uninstall Longhorn

To uninstall Longhorn, change `defaultSettings.deletingConfirmationFlag` in file `values.yaml` to `true` or running command:

```bash
k edit settings.longhorn.io deleting-confirmation-flag -n longhorn
```
