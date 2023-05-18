resource "google_secret_manager_secret" "secret" {
  secret_id = var.secret_name

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "version" {
  secret        = google_secret_manager_secret.secret.id
  secret_data   = var.secret_value
  depends_on    = [google_secret_manager_secret.secret]
}

