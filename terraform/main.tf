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

module "network" {
  source               = "./modules/network"

  region               = var.region
  project              = var.project
}

module "k8s" {
  source               = "./modules/k8s"

  region               = var.region
  project              = var.project
  network_name         = module.network.net_name
  subnet_name          = module.network.subnet_name
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