# Install Cloudnative-pg Opeartors

**Step 1:** Add `cnpg` repository to helm and update helm for the latest version:

```bash
helm repo add cnpg https://cloudnative-pg.github.io/charts

helm update
```

**Step 2:** Install Cloudnative-pg operator to the `operators` namespace:

```bash
helm upgrade -i cnpg-operator --namespace operators --create-namespace cnpg/cloudnative-pg
```
