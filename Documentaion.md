# Task 2 - Local Kubernetes Cluster

This lab creates a Kubernetes cluster with one control-plane node and one worker node using Minikube and the Docker driver. The administrative API endpoint published on the Windows host is bound to localhost.

## Tested environment

| Component | Version or setting 
| Minikube | v1.39.0 |
| Kubernetes | v1.35.8 |
| kubectl | v1.35.8 |


Docker Desktop, Minikube, kubectl, and Git must be installed. Hardware virtualization and the required WSL features must be enabled.

## Create the cluster


minikube start -p devops-lab --driver=docker --nodes=2 --kubernetes-version=v1.35.8 --cpus=2 --memory=3072 --listen-address=127.0.0.1 --wait=apiserver,system_pods,node_ready


`--nodes=2` requests two nodes in total: one control plane and one worker. Each node runs in its own Docker container on the same computer.


## Verify the cluster

kubectl --context devops-lab get nodes -o wide
kubectl --context devops-lab get pods -n kube-system
minikube status -p devops-lab


The following node states were observed:

| Node | Role | Status |
| `devops-lab` | Control plane | Ready |
| `devops-lab-m02` | Worker | Ready |


## API network access

The lab's published administrative API endpoint is restricted to host-local access through the `127.0.0.1` binding. Inspect the mapping with:


docker port devops-lab 8443/tcp


Observed output:

127.0.0.1:53889


`8443` is the API port inside the control-plane container. 
`53889` is the observed published host port; it can change when the cluster is recreated.

The verified evidence is the localhost port mapping. A separate test from another computer was not performed. This setup implements local-only administrative access, rather than a firewall allowlist for selected remote client IP addresses. If assessment requires access from selected remote computers, additional source-IP filtering and allowed/denied client tests are still needed. Internal Kubernetes node and Pod networking is separate from the host port binding.


## Credentials and required access rights

Minikube configures the client credentials in kubeconfig for the
`devops-lab` context.

The operator needs permissions to manage application resources and
install ingress-nginx, including its cluster-scoped RBAC, IngressClass,
and admission webhook resources.

Keep kubeconfig files, private keys, tokens, and passwords outside Git.

