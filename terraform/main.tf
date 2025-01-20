provider "google" {
  credentials = file("${path.module}/helm-service-account-key.json") # Ruta relativa al archivo
  project     = var.project_id
  region      = var.region
}

resource "google_artifact_registry_repository" "reference_registry" {
  repository_id = "reference-registry" # Nombre del repositorio de origen
  location      = var.region
  format        = "DOCKER"
  description   = "Source registry for Helm charts"
}

resource "google_artifact_registry_repository" "instance_registry" {
  repository_id = "instance-registry" # Nombre del repositorio de destino
  location      = var.region
  format        = "DOCKER"
  description   = "Destination registry for Helm charts"
}

resource "null_resource" "copy_helm_charts" {
  provisioner "local-exec" {
    command = "./helm_copy.sh"
  }
}
