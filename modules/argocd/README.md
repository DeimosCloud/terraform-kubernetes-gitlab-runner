# Terraform-argocd
Setup ArgoCD on cluster using terraform. Ensure the `kubernetes` provider configuration and `helm` provider configuration works fine

## Usage


### Argocd with Nginx Ingress Controller
```hcl

locals {
  # Example annotations when using Nginx ingress controller as shown here https://argoproj.github.io/argo-cd/operator-manual/ingress/#option-1-ssl-passthrough
  argocd_ingress_annotations = {
    "kubernetes.io/ingress.class" = nginx
    "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
    "nginx.ingress.kubernetes.io/ssl-passthrough" = "true"
  }
}

module "argocd" {
  source              = "https://gitlab.com/deimosdev/tooling/terraform-modules/terraform-argocd"
  git_url             = var.argocd_gitops_repo
  git_access_token    = var.argocd_access_token
  ingress_host        = "argocd.${var.dns_zone_name}"
  ingress_annotations = local.argocd_ingress_annotations

  module_depends_on = [module.external_dns, module.ingress_controller, module.cert_manager]
}
```

### Argocd with Azure Application Gateway Ingress Controller
```hcl
locals {
  # Example annotations when using Azure application gateway Ingress Controller with Cert-manager
  argocd_ingress_annotations = {
    "cert-manager.io/cluster-issuer"           = module.cert_manager.issuer
    "appgw.ingress.kubernetes.io/ssl-redirect" = "true"
    "kubernetes.io/ingress.class"              = "azure/application-gateway"
  }
}

module "argocd" {
  source              = "https://gitlab.com/deimosdev/tooling/terraform-modules/terraform-argocd"
  git_url             = var.argocd_gitops_repo
  git_access_token    = var.argocd_access_token
  ingress_host        = "argocd.${var.dns_zone_name}"
  ingress_annotations = local.argocd_ingress_annotations
  server_insecure     = true # Run argocd-server in secure mode to prevent SSL conflicts with application/gateway and cert-manager

  module_depends_on = [module.external_dns, module.ingress_controller, module.cert_manager]
}
```
#### Ensure Kubernetes Provider and Helm Provider settings are correct

##### Example showing a sample of valid AKS provider config
```hcl
# Example Kubernetes Provider settings for AKS
provider kubernetes {
  host                   = module.aks.host
  client_certificate     = base64decode(module.aks.client_certificate)
  client_key             = base64decode(module.aks.client_key)
  cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
  load_config_file       = false
}

# Kubernetes Provider settings for AKS
provider helm {
  kubernetes {
    host                   = module.aks.host
    client_certificate     = base64decode(module.aks.client_certificate)
    client_key             = base64decode(module.aks.client_key)
    cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
    load_config_file       = false
  }
}
```
##### Example showing a sample of valid GKE Provider config
```hcl
# Example Kubernetes Provider settings GKE
provider "kubernetes" {
  load_config_file       = false
  host                   = module.gke.endpoint
  token                  = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

provider "helm" {
  kubernetes {
    load_config_file       = false
    host                   = module.gke.endpoint
    token                  = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(module.gke.ca_certificate)
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| helm | >=1.2.3 |
| kubernetes | >=1.11.3 |

## Providers

| Name | Version |
|------|---------|
| helm | >=1.2.3 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| chart\_version | version of charts | `string` | `"2.5.4"` | no |
| git\_access\_token | An Optional Access Token for git authentication | `any` | `null` | no |
| git\_password | The password for the user | `any` | `null` | no |
| git\_ssh\_key | sshkey for authentication | `any` | `null` | no |
| git\_url | the url of the git repo to authenticate to | `any` | n/a | yes |
| git\_username | Username for authentication | `any` | `null` | no |
| ingress\_annotations | annotations to pass to the ingress | `map` | `{}` | no |
| ingress\_host | The ingress host | `any` | `null` | no |
| ingress\_tls\_secret | The TLS secret name for argocd ingress | `string` | `"argocd-server-tls"` | no |
| module\_depends\_on | resources that the module depends on, aks, namespace creation etc | `any` | `null` | no |
| namespace | The namespace to deploy argocd into | `string` | `"argocd"` | no |
| server\_extra\_args | Extra arguments passed to argoCD server | `list` | `[]` | no |
| server\_insecure | Whether to run the argocd-server with --insecure flag. Useful when disabling argocd-server tls default protocols to provide your certificates | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| namespace | the kubernetes namespace of the release |
| release\_name | the name of the release |
