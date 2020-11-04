# Terraform-argocd
Setup ArgoCD on cluster using terraform. Ensure the `kubernetes` provider configuration and `helm` provider configuration works fine

## Usage

```hcl

#------------------------------------------------------------------------------------------------------------------------
# Gitlab Runner
#
# Provision gitlab-runner with https://docs.gitlab.com/ee/ci/docker/using_docker_build.html#use-docker-socket-binding
# To allow running and caching docker images
#------------------------------------------------------------------------------------------------------------------------
module "gitlab_runner" {
  source       = "../modules/gitlab-runner"
  release_name = "gitlab-runner"

  runner_tags               = var.runner_tags
  runner_registration_token = var.runner_registration_token

  depends_on = [module.gke]
}
```

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

Full contributing guidelines are covered [here](CONTRIBUTIONS.md).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
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
| kubernetes | >=1.11.3 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_role | Cluster role for gitlab runner rbac | `string` | `"gitlab-runner-admin"` | no |
| cluster\_role\_binding | Cluster role for gitlab runner rbac | `string` | `"gitlab-runner-admin"` | no |
| namespace | n/a | `string` | `"gitlab-runner"` | no |
| release\_name | The helm release name | `string` | `"gitlab-runner"` | no |
| runner\_registration\_token | runner registration token | `string` | n/a | yes |
| runner\_tags | runner tags | `string` | n/a | yes |
| service\_account | The name of the Service account to create | `string` | `"gitlab-runner-admin"` | no |

## Outputs

| Name | Description |
|------|-------------|
| namespace | The namespace gitlab-runner was deployed in |
| release\_name | The helm release name |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->