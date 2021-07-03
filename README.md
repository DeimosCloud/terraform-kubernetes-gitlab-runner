# Terraform Kubernetes Gitlab-Runner Module
Setup Gitlab Runner on cluster using terraform. Ensure the `kubernetes` provider configuration and `helm` provider configuration works fine

## Usage

```hcl
module "gitlab_runner" {
  source                    = "DeimosCloud/gitlab-runner/kubernetes"
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
| azure\_cache\_conf | Cache parameters define using Azure Blob Storage for caching as seen https://docs.gitlab.com/runner/configuration/advanced-configuration.html#the-runnerscacheazure-section. Only used when var.use\_local\_cache is false | `map` | `{}` | no |
| build\_dir | Path on nodes for caching | `string` | `null` | no |
| cache\_path | Name of the path to prepend to the cache URL. Only used when var.use\_local\_cache is false | `any` | `null` | no |
| cache\_shared | Enables cache sharing between runners. Only used when var.use\_local\_cache is false | `bool` | `false` | no |
| cache\_type | One of: s3, gcs, azure. Only used when var.use\_local\_cache is false | `any` | `null` | no |
| chart\_version | The version of the chart | `string` | `"0.28.0-rc1"` | no |
| concurrent | Configure the maximum number of concurrent jobs | `number` | `10` | no |
| create\_namespace | (Optional) Create the namespace if it does not yet exist. Defaults to false. | `bool` | `true` | no |
| create\_service\_account | If true, the service account, it's role and rolebinding will be created, else, the service account is assumed to already be created | `bool` | `true` | no |
| default\_container\_image | Default container image to use for builds when none is specified | `string` | `"ubuntu:18.04"` | no |
| docker\_fs\_group | The fsGroup to use for docker. This is added to security context when mount\_docker\_socket is enabled | `number` | `412` | no |
| gcs\_cache\_conf | Cache parameters define using Azure Blob Storage for caching as seen https://docs.gitlab.com/runner/configuration/advanced-configuration.html#the-runnerscachegcs-section. Only used when var.use\_local\_cache is false | `map` | `{}` | no |
| gitlab\_url | The GitLab Server URL (with protocol) that want to register the runner against | `string` | `"https://gitlab.com/"` | no |
| local\_cache\_dir | Path on nodes for caching | `string` | `"/tmp/gitlab/cache"` | no |
| mount\_docker\_socket | Path on nodes for caching | `bool` | `false` | no |
| namespace | n/a | `string` | `"gitlab-runner"` | no |
| node\_selectors | A map of node selectors to apply to the pods | `map` | `{}` | no |
| node\_tolerations | A map of node tolerations to apply to the pods as defined https://docs.gitlab.com/runner/executors/kubernetes.html#other-configtoml-settings | `map` | `{}` | no |
| pod\_annotations | A map of annotations to be added to each build pod created by the Runner. The value of these can include environment variables for expansion. Pod annotations can be overwritten in each build. | `map` | `{}` | no |
| pod\_labels | A map of labels to be added to each build pod created by the runner. The value of these can include environment variables for expansion. | `map` | `{}` | no |
| priviledged | Run all containers with the privileged flag enabled. This will allow the docker:dind image to run if you need to run Docker | `bool` | `false` | no |
| release\_name | The helm release name | `string` | `"gitlab-runner"` | no |
| run\_container\_as\_user | SecurityContext: runAsUser for all running job pods | `string` | `null` | no |
| run\_untagged\_jobs | Specify if jobs without tags should be run. https://docs.gitlab.com/ce/ci/runners/#runner-is-allowed-to-run-untagged-jobs | `bool` | `false` | no |
| runner\_image\_tag | The docker gitlab runner version. https://hub.docker.com/r/gitlab/gitlab-runner/tags/ | `string` | `"alpine-v13.11.0-rc1"` | no |
| runner\_locked | Specify whether the runner should be locked to a specific project/group | `string` | `true` | no |
| runner\_registration\_token | runner registration token | `string` | n/a | yes |
| runner\_tags | Specify the tags associated with the runner. Comma-separated list of tags. | `string` | n/a | yes |
| s3\_cache\_conf | Cache parameters define using S3 for caching as seen https://docs.gitlab.com/runner/configuration/advanced-configuration.html#the-runnerscaches3-section. Only used when var.use\_local\_cache is false | `map` | `{}` | no |
| secret\_volumes | Secret volume configuration instructs Kubernetes to use a secret that is defined in Kubernetes cluster and mount it inside of the containes as defined https://docs.gitlab.com/runner/executors/kubernetes.html#secret-volumes | <pre>object({<br>    name       = string<br>    mount_path = string<br>    read_only  = string<br>    items      = map(string)<br>  })</pre> | <pre>{<br>  "items": {},<br>  "mount_path": null,<br>  "name": null,<br>  "read_only": null<br>}</pre> | no |
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
