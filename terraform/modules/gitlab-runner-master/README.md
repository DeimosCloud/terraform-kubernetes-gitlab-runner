# Terraform Kubernetes Gitlab-Runner Module
Setup ArgoCD on cluster using terraform. Ensure the `kubernetes` provider configuration and `helm` provider configuration works fine

## Usage

```hcl
module "gitlab_runner" {
  source                    = "git::ssh://git@gitlab.com/deimosdev/tooling/terraform-modules/terraform-kubernetes-gitlab-runner.git"
  release_name              = "${var.project_name}-runner-${var.environment}"
  runner_tags               = var.runner_tags
  runner_registration_token = var.runner_registration_token
  default_runner_image      = var.default_runner_image
  namespace                 = var.gitlab_runner_namespace

  # Pass annotations to service account. This can be for workload/pod/ identity
  service_account_annotations = {
    "iam.gke.io/gcp-service-account" = module.workload_identity["gitlab-runner"].gcp_service_account_email
  }

  # Use Local cache on Kubernetes nodes
  use_local_cache     = true

  # Mount docker socket instead of using docker-in-docker
  mount_docker_socket = true

  depends_on = [module.gke_cluster, module.gke_node_pool]
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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| build\_dir | Path on nodes for caching | `string` | `null` | no |
| chart\_version | The version of the chart | `string` | `"0.28.0-rc1"` | no |
| cluster\_role | Cluster role for gitlab runner rbac | `string` | `"gitlab-runner-admin"` | no |
| cluster\_role\_binding | Cluster role for gitlab runner rbac | `string` | `"gitlab-runner-admin"` | no |
| concurrent | Configure the maximum number of concurrent jobs | `number` | `10` | no |
| create\_namespace | (Optional) Create the namespace if it does not yet exist. Defaults to false. | `bool` | `true` | no |
| default\_container\_image | Default container image to use for builds when none is specified | `string` | `"ubuntu:18.04"` | no |
| docker\_fs\_group | The fsGroup to use for docker. This is added to security context when mount\_docker\_socket is enabled | `number` | `412` | no |
| gitlab\_url | The GitLab Server URL (with protocol) that want to register the runner against | `string` | `"https://gitlab.com/"` | no |
| local\_cache\_dir | Path on nodes for caching | `string` | `"/tmp/gitlab/cache"` | no |
| mount\_docker\_socket | Path on nodes for caching | `bool` | `false` | no |
| namespace | n/a | `string` | `"gitlab-runner"` | no |
| priviledged | Run all containers with the privileged flag enabled. This will allow the docker:dind image to run if you need to run Docker | `bool` | `false` | no |
| rbac\_enabled | For RBAC Support | `bool` | `true` | no |
| release\_name | The helm release name | `string` | `"gitlab-runner"` | no |
| run\_container\_as\_user | SecurityContext: runAsUser for all running job pods | `string` | `null` | no |
| run\_untagged\_jobs | Specify if jobs without tags should be run. https://docs.gitlab.com/ce/ci/runners/#runner-is-allowed-to-run-untagged-jobs | `bool` | `false` | no |
| runner\_image\_tag | The docker gitlab runner version. https://hub.docker.com/r/gitlab/gitlab-runner/tags/ | `string` | `"alpine-v13.11.0-rc1"` | no |
| runner\_locked | Specify whether the runner should be locked to a specific project/group | `string` | `true` | no |
| runner\_registration\_token | runner registration token | `string` | n/a | yes |
| runner\_tags | Specify the tags associated with the runner. Comma-separated list of tags. | `string` | n/a | yes |
| service\_account | The name of the Service account to create | `string` | `"gitlab-runner"` | no |
| service\_account\_annotations | The annotations to add to the service account | `map` | `{}` | no |
| service\_account\_clusterwide\_access | Run the gitlab-bastion container with the ability to deploy/manage containers of jobs cluster-wide or only within namespace | `bool` | `false` | no |
| use\_local\_cache | Use path on nodes for caching | `bool` | `false` | no |
| values\_file | Path to Values file to be passed to gitlab-runner helm templates | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| chart\_version | The chart version |
| namespace | The namespace gitlab-runner was deployed in |
| release\_name | The helm release name |
| runner\_version | The runner version |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
