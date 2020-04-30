---
id: static
title: Static secrets 
sidebar_label: Static secrets
---

The most basic form of secret 


## Writing secrets to Vault

To write a secret to Vault you can use the CLI as shown below, this command will write key value pairs.

```
vault kv put secret/web payments_api_key=abcdefg username=nic
```

<Terminal target="tools.container.shipyard.run" shell="/bin/bash" workdir="/files" user="root" />
<p></p>

## Reading static secrets

To read a secret you can use the `read` command to read a secret in Vault

```
vault kv get secret/web
```

<Terminal target="tools.container.shipyard.run" shell="/bin/bash" workdir="/files" user="root" />
<p></p>

## Configuring Kubernetes

To inject these secrets into a our Pod and create an application specific config file, you can use the annotations demonstrated in the previous section. This example will generate a configuration file at `/vault/secrets/config` which can be read by the application.

```yaml
vault.hashicorp.com/agent-inject: "true"
vault.hashicorp.com/role: "web"
vault.hashicorp.com/agent-inject-secret-config: "secret/data/web"
vault.hashicorp.com/agent-inject-template-config: |
  {
    "db_connection": "host=postgres port=5432 user=postgres password=password dbname=products sslmode=disable",
    "bind_address": ":9090",
    {{ with secret "secret/data/web" -}}
      "api_key": "{{ .Data.data.payments_api_key }}"
    {{- end }}
  }
```

To access the secret your application needs to have permission, this is configured through Vault policy. The following example shows the minimum policy needed to read the static secrets in the document `web`. 

```javascript
path "secret/data/web" {
  capabilities = ["read"]
}
```

You can apply this policy with the following command:

```shell
vault policy write web ./web-policy.hcl
```

<Terminal target="tools.container.shipyard.run" shell="/bin/bash" workdir="/files" user="root" />
<p></p>

Now this has been configured you can run your deployment manifest is show below:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-deployment
  labels:
    app: web
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
      annotations:
        vault.hashicorp.com/agent-inject: "true"
        vault.hashicorp.com/role: "web"
        vault.hashicorp.com/agent-inject-secret-config: "secret/data/web"
        vault.hashicorp.com/agent-inject-template-config: |
          {
            "db_connection": "host=postgres port=5432 user=postgres password=password dbname=products sslmode=disable",
            "bind_address": ":9090",
            {{ with secret "secret/data/web" -}}
              "api_key": "{{ .Data.data.payments_api_key }}"
            {{- end }}
          }
    spec:
      serviceAccountName: web
      containers:
        - name: web
          image: nicholasjackson/vault-demo-app:v0.0.1
          imagePullPolicy: IfNotPresent
          ports:
            - containerPort: 9090
          env:
            - name: "CONFIG_FILE"
              value: "/vault/secrets/config"
```

You can run this using the command:

```
kubectl apply -f /files/config/static.yml
```

<Terminal target="tools.container.shipyard.run" shell="/bin/bash" workdir="/files" user="root" />
<p></p>

To see the generated config run the following command:

```
kubectl exec -it \
  $(kubectl get pods --selector "app=web" -o jsonpath="{.items[0].metadata.name}") \
  -c vault-agent -- \
  cat /vault/secrets/config
```

<Terminal target="tools.container.shipyard.run" shell="/bin/bash" workdir="/files" user="root" />
<p></p>