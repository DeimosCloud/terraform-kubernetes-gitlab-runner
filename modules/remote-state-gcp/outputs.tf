output "bucket_name" {
  value       = google_storage_bucket.state.name
  description = "Name of created bucket"
}

output "prefix" {
  description = "GCS Prefix inside the bucket"
  value       = var.prefix
}

output "bucket_url" {
  value       = google_storage_bucket.state.url
  description = "The base URL of the bucket, in the format gs://<bucket-name>"
}
