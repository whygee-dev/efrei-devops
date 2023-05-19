
resource "google_container_cluster" "primary" {
  name     = "k8s-cluster"
  location = var.region

  network    = var.network_name
  subnetwork = var.subnet_name

  ip_allocation_policy {}

  enable_autopilot = true
}