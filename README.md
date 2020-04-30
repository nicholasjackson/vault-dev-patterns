# Application Development Patterns managing secrets with HashiCorp Vault and Kubernetes

This repository contains example patterns to help secure Kubernetes applications.

## Patterns

* Static Secrets
* Dynamic Database Credentials
* Generating X509 Keys and Certificates for TLS endpoints
* Using Vault's encyrption as a service to encrypt personally identifiable data

## Contents

./application  - Go based sample application
./blueprint - Shipyard blueprint for creating K8s and Vault cluster locally

## Requirements for running examples

The example Kubernetes application runs locally on your computer, no cloud needed just two simple tools:

* [Docker](https://docker.io)
* [Shipyard](https://shipyard.run)

## Running the examples

All required resources, and documentation are created using [Shipyard](https://shipyard.run).

Running the command `shipyard run ./blueprint` will create and configure the following elements using Docker.

* Single node Kubernetes Cluster with K3s
* Vault server installed using the Vault Helm chart
* PostgreSQL database
* Simple web application which implements patterns
* Ingress providing access to Vault Server running in K8s - http://vault.ingress.shipyard.run:8200
* Ingress providing access to a simple web application - http://web.ingress.shipyard.run:9090
* Interactive documentation for the patterns - http://docs.docs.shipyard.run:8080

```
➜ shipyard run ./blueprint 
Running configuration from:  ./blueprint

2020-04-30T14:06:33.482+0100 [DEBUG] Statefile does not exist
2020-04-30T14:06:33.482+0100 [INFO]  Creating Network: ref=cloud
```

Shipyard is cross platform and works on Windows, Linux, and Mac.

## Interacting with the demo

You can interact with the demo stack either throught the interactive documentation or by setting the following environment variables and using your local 
tooling.

```
KUBECONFIG=$HOME/.shipyard/config/k3s/kubeconfig.yaml
VAULT_ADDR=http://vault.ingress.shipyard.run:8200
VAULT_TOKEN=root
```

Setting the environment variables is also possible using the Shipyard `env` command:

```
eval $(shipyard env)
```

## Destroying the demo

To destroy the demo simply run the following command:

```
shipyard destroy
```