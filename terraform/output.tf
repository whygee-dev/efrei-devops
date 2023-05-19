output "region" {
  value       = var.region
  description = "GCloud Region"
}

output "project_id" {
  value       = var.project
  description = "GCloud Project ID"
}

output "kubernetes_cluster_name" {
  value       = module.k8s.kubernetes_cluster_name
  description = "GKE Cluster Name"
}

output "kubernetes_cluster_host" {
  value       = module.k8s.kubernetes_cluster_host
  description = "GKE Cluster Host"
}
