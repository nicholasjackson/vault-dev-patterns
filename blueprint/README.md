---
title: "HashiCorp Vault and Kubernetes"
author: "Nic Jackson"
slug: "vault_k8s"
browser_windows: "http://k8s-dashboard.ingress.shipyard.run:18443,http://docs.docs.shipyard.run:18080"
env:
  - KUBECONFIG=$HOME/.shipyard/config/k3s/kubeconfig.yaml
  - VAULT_ADDR=http://vault.ingress.shipyard.run:8200
  - VAULT_TOKEN=root
---

This blueprint creates a Kubernetes cluster with Vault Helm chart installed

## Vault UI
To access the Vault UI point your browser at:

`http://vault.ingress.shipyard.run:8200`

The token `root` can be used to authenticate

## Interactive Documentation
To view the interactive documentation and walk through of using Vault Dynmamic secrets with PostgresSQL
please check out the docs at:

`http://docs.docs.shipyard.run:18080`
  
## Cleanup

Run `shipyaryard destroy` to cleanup all resources

## Components
* Kubernetes
* HashiCorp Vault (installed with Helm)
* Examples for static secrets, database secrets, X509 certificates, encryption as a service
