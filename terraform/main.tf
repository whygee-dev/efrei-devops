terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
    }
  }
}

provider "google" {
  project     = var.project
  region      = var.region
}

# VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.project}-vpc"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project}-subnet"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"
}

resource "google_container_cluster" "primary" {
  name     = "k8s-cluster"
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
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
    max_node_count = 3
  }
}

module "discord_client_id" {
  source                = "./modules/secret_manager"

  region              = var.region

  secret_name           = "DISCORD_CLIENT_ID"
  secret_value          = var.discord_client_id
}

module "discord_client_secret" {
  source                = "./modules/secret_manager"

  region              = var.region

  secret_name           = "DISCORD_CLIENT_SECRET"
  secret_value          = var.discord_client_secret
}

module "nextauth_secret" {
  source                = "./modules/secret_manager"

  region              = var.region

  secret_name           = "NEXTAUTH_SECRET"
  secret_value          = var.nextauth_secret
}

module "database_url" {
  source                = "./modules/secret_manager"

  region                = var.region

  secret_name           = "DATABASE_URL"
  secret_value          = var.database_url
}


module "container_registry" {
  source               = "./modules/registry"  

  location             = var.region
}