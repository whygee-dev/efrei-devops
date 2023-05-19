variable "region" {
  type        = string
}

variable "project" {
  type        = string
}

variable "discord_client_id" {
  type        = string
}

variable "discord_client_secret" {
  type        = string
}

variable "nextauth_secret" {
  type        = string
}

variable "database_url" {
  type        = string
}

variable "trigger_name" {
    type = string
}

variable "github_repo" {
    type = string
}

variable "github_branch" {
    type = string
    default = "^master$"
}