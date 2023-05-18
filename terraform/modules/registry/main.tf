resource "google_artifact_registry_repository" "efrei-devops" {
  repository_id = "efrei-devops"
  format        = "DOCKER"
  location      = var.location
}