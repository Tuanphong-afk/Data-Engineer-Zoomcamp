terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.20.0"
    }
  }
}

provider "google" {
  project = "disco-stock-487216-q9"
  region  = "asia-southeast1"

}


resource "google_storage_bucket" "demo-bucket" {
  name          = "disco-stock-487216-q9-terra-bucket"
  location      = "asia-southeast1"
  force_destroy = true


  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}