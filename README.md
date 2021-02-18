# Terraform Kubernetes Gitlab-Runner Module
Setup ArgoCD on cluster using terraform. Ensure the `kubernetes` provider configuration and `helm` provider configuration works fine

## Usage

Usage example is present in [examples](./examples) directory.

Ensure Kubernetes Provider and Helm Provider settings are correct https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/guides/getting-started#provider-setup

## Doc generation

Code formatting and documentation for variables and outputs is generated using [pre-commit-terraform hooks](https://github.com/antonbabenko/pre-commit-terraform) which uses [terraform-docs](https://github.com/segmentio/terraform-docs).

Follow [these instructions](https://github.com/antonbabenko/pre-commit-terraform#how-to-install) to install pre-commit locally.

And install `terraform-docs` with
```bash
go get github.com/segmentio/terraform-docs
```
or
```bash
brew install terraform-docs.
```

## Contributing

Report issues/questions/feature requests on in the issues section.

Full contributing guidelines are covered [here](CONTRIBUTING.md).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| helm | ~> 1.3 |
| kubernetes | ~> 1.13 |

## Providers

| Name | Version |
|------|---------|
| helm | ~> 1.3 |
| kubernetes | ~> 1.13 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_role | Cluster role for gitlab runner rbac | `string` | `"gitlab-runner-admin"` | no |
| cluster\_role\_binding | Cluster role for gitlab runner rbac | `string` | `"gitlab-runner-admin"` | no |
| default\_runner\_image | Runner Tags | `string` | n/a | yes |
| namespace | n/a | `string` | `"gitlab-runner"` | no |
| release\_name | The helm release name | `string` | `"gitlab-runner"` | no |
| runner\_registration\_token | runner registration token | `string` | n/a | yes |
| runner\_tags | runner tags | `string` | n/a | yes |
| service\_account | The name of the Service account to create | `string` | `"gitlab-runner-admin"` | no |
| values\_file | Path to Values file to be passed to gitlab-runner helm templates | `string` | `"gitlab-runner/values.yaml"` | no |

## Outputs

| Name | Description |
|------|-------------|
| namespace | The namespace gitlab-runner was deployed in |
| release\_name | The helm release name |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
