#!/bin/bash

# Variables
REFERENCE_REGISTRY="us-central1-docker.pkg.dev/shining-relic-447714-i8/reference-registry"
INSTANCE_REGISTRY="us-central1-docker.pkg.dev/shining-relic-447714-i8/instance-registry"
CHART_NAME="ping"
CHART_VERSION="0.1.0"

# Autenticación con Artifact Registry
gcloud auth configure-docker us-central1-docker.pkg.dev

# Descargar el chart desde el repositorio de referencia
helm chart pull oci://$REFERENCE_REGISTRY/$CHART_NAME:$CHART_VERSION

# Subir el chart al repositorio de destino
helm chart push oci://$INSTANCE_REGISTRY/$CHART_NAME:$CHART_VERSION
