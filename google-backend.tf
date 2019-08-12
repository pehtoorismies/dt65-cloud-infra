terraform {
  backend "gcs" {
    bucket  = "tf-state.downtown65.com"
    prefix  = "terraform/state"
    credentials = "cloud-credentials.json"
  }
}