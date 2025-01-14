#!/bin/bash
set -e

# Variables
REFERENCE_REGISTRY="us-central1-docker.pkg.dev/shining-relic-447714-i8/reference-registry"
INSTANCE_REGISTRY="us-central1-docker.pkg.dev/shining-relic-447714-i8/instance-registry"
CHART_NAME="ping"
CHART_VERSION="0.1.0"

# Configura autenticación para los registros
gcloud auth configure-docker $REFERENCE_REGISTRY
gcloud auth configure-docker $INSTANCE_REGISTRY

# Descarga el Helm chart desde el registro de origen
helm pull oci://$REFERENCE_REGISTRY/$CHART_NAME --version $CHART_VERSION

# Sube el Helm chart al registro de destino
helm push $CHART_NAME-$CHART_VERSION.tgz oci://$INSTANCE_REGISTRY
