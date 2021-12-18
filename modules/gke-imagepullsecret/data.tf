data "google_secret_manager_secret_version" "registry_server" {
  secret = "DEV_AUTH_REGISTERY_SERVER"
}

data "google_secret_manager_secret_version" "registry_username" {
  secret = "DEV_AUTH_REGISTERY_USERNAME"
}

data "google_secret_manager_secret_version" "registry_password" {
  secret = "DEV_AUTH_REGISTERY_PASSWORD"
}