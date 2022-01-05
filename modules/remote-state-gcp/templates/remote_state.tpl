terraform {
  backend "gcs" {
    bucket      = "${bucket_name}"
    prefix      = "${prefix}"
    credentials = "${credentials_config}"
  }
}
