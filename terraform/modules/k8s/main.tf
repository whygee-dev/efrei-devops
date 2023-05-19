
resource "google_container_cluster" "primary" {
  name     = "k8s-cluster"
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.network_name
  subnetwork = var.subnet_name
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "k8s-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  initial_node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-small"

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 10
  }
}