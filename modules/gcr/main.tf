#------------------------------
# Ensure GCR Bucket Exists
#------------------------------
resource "google_container_registry" "registry" {
  project  = var.project
  location = var.location
}
