data "google_secret_manager_secret_version" "private_gke_runner_registration_token" {
  secret = "private_gke_runner_registration_token"
}

data "google_secret_manager_secret_version" "registry_server" {
  secret = "DEV_AUTH_REGISTERY_SERVER"
}

data "google_secret_manager_secret_version" "registry_username" {
  secret = "DEV_AUTH_REGISTERY_USERNAME"
}

data "google_secret_manager_secret_version" "registry_password" {
  secret = "DEV_AUTH_REGISTERY_PASSWORD"
}