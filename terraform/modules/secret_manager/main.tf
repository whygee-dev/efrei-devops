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

data "google_iam_policy" "admin" {
  binding {
    role = "roles/secretmanager.secretAccessor"
    members = [
      "serviceAccount:292481049315@cloudbuild.gserviceaccount.com",
    ]
  }
}

resource "google_secret_manager_secret_version" "version" {
  secret        = google_secret_manager_secret.secret.id
  secret_data   = var.secret_value
  depends_on    = [google_secret_manager_secret.secret]
}

resource "google_secret_manager_secret_iam_policy" "policy" {
  project      = google_secret_manager_secret.secret.project
  secret_id    = google_secret_manager_secret.secret.secret_id
  policy_data  = data.google_iam_policy.admin.policy_data
}
