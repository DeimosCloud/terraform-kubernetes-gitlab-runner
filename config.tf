locals {
  config = <<EOF
[[runners]]
%{if var.use_local_cache~}
  cache_dir = "${var.local_cache_dir}"
%{~else~}
  %{if var.cache_type != null~}
  [runners.cache]
    Type = "${var.cache_type}"
    Path = "${var.cache_path}"
    Shared = ${var.cache_shared}
    [runners.cache.s3]
    %{~for key, value in var.s3_cache_conf~}
      "${key}" = "${value}"
    %{~endfor~}
    [runners.cache.gcs]
    %{~for key, value in var.gcs_cache_conf~}
      "${key}" = "${value}"
    %{~endfor~}
    [runners.cache.azure]
    %{~for key, value in var.azure_cache_conf~}
      "${key}" = "${value}"
    %{~endfor~}
    %{~endif~}
%{~endif}
  [runners.kubernetes]
  %{~if var.build_job_default_container_image != null~}
    image = "${var.build_job_default_container_image}"
  %{~endif~}
  %{~if var.create_service_account == true~}
    service_account = "${var.release_name}-${var.service_account}"
  %{~else~}
    service_account = "${var.service_account}"
  %{~endif~}
    image_pull_secrets = ${jsonencode(var.image_pull_secrets)}
    privileged      = ${var.build_job_privileged}
    [runners.kubernetes.affinity]
    [runners.kubernetes.node_selector]
    %{~for key, value in var.build_job_node_selectors~}
      "${key}" = "${value}"
    %{~endfor~}
    [runners.kubernetes.node_tolerations]
    %{~for key, value in var.build_job_node_tolerations~}
      "${key}" = "${value}"
    %{~endfor~}
    [runners.kubernetes.pod_labels]
    %{~for key, value in var.build_job_pod_labels~}
      "${key}" = "${value}"
    %{~endfor~}
    [runners.kubernetes.pod_annotations]
    %{~for key, value in var.build_job_pod_annotations~}
      "${key}" = "${value}"
    %{~endfor~}
    [runners.kubernetes.pod_security_context]
    %{~if var.build_job_mount_docker_socket~}
      fs_group = ${var.docker_fs_group}
    %{~endif~}
    %{~if var.build_job_run_container_as_user != null~}
      run_as_user: ${var.build_job_run_container_as_user}
    %{~endif~}
    [runners.kubernetes.volumes]
    %{~if var.build_job_mount_docker_socket~}
      [[runners.kubernetes.volumes.host_path]]
        name = "docker-socket"
        mount_path = "/var/run/docker.sock"
        read_only = true
        host_path = "/var/run/docker.sock"
    %{~endif~}
    %{~if var.use_local_cache~}
      [[runners.kubernetes.volumes.host_path]]
        name = "cache"
        mount_path = "${var.local_cache_dir}"
        host_path = "${var.local_cache_dir}"
    %{~endif~}
    %{~if lookup(var.build_job_secret_volumes, "name", null) != null~}
      [[runners.kubernetes.volumes.secret]]
        name = ${lookup(var.build_job_secret_volumes, "name", "")}
        mount_path = ${lookup(var.build_job_secret_volumes, "mount_path", "")}
        read_only = ${lookup(var.build_job_secret_volumes, "read_only", "")}
        [runners.kubernetes.volumes.secret.items]
          %{~for key, value in lookup(var.build_job_secret_volumes, "items", {})~}
            ${key} = ${value}
          %{~endfor~}
    %{~endif~}
EOF
}
