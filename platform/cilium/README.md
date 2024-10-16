# Use Cilium to Replace kube-proxy on RKE2

To provision a RKE2 cluster without `kube-proxy` and to use Cilium to fully replace it, you need to disable the `kube-proxy` on all RKE2 servers by add the following configuration to `/etc/rancher/rke2/config.yaml`:

```
disable-kube-proxy: "true"
```

If `kube-proxy` is already running on your RKE2 cluster, you need to delete `kube-proxy.yaml` file by running command:

```bash
sudo rm /var/lib/rancher/rke2/agent/pod-manifests/kube-proxy.yaml
```

Afterward, restart the RKE2 server:

```bash
sudo systemctl restart rke2-server
```

You also need to changes values in `values.yaml` file then redeploy Cilium chart:

```yaml
# -- Configure the kube-proxy replacement in Cilium BPF datapath
# Valid options are "true" or "false".
# ref: https://docs.cilium.io/en/stable/network/kubernetes/kubeproxy-free/
kubeProxyReplacement: "true"

# -- (string) Kubernetes service host - use "auto" for automatic lookup from the cluster-info ConfigMap (kubeadm-based clusters only)
# K8s api-server's IP address, you can get it by running: kubectl get po <API_SERVER_NAME> -n kube-system -o yaml | grep hostIP
k8sServiceHost: "192.168.65.102"

# -- (string) Kubernetes service port
# K8s api-server's IP port, you can get it by running: kubectl get po <API_SERVER_NAME> -n kube-system -o yaml | grep port (default 6443 by kubeadm)
k8sServicePort: "6443"
```