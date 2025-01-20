# **Deploy Helm Chart to GKE**

Este proyecto permite desplegar un Helm Chart en un clúster de Google Kubernetes Engine (GKE) utilizando GitHub Actions. Proporciona un pipeline CI/CD completo con autenticación segura, gestión de dependencias y pruebas automatizadas.

## **Requisitos previos**

Antes de ejecutar este proyecto, asegúrate de cumplir con los siguientes requisitos:

### **Herramientas necesarias**
- [Git](https://git-scm.com/)
- [Helm v3.9+](https://helm.sh/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)

## **Infraestructura con Terraform**

El proyecto incluye una configuración con Terraform dentro de la rama principal (`main`). Esta configuración automatiza la creación y configuración de los recursos necesarios en Google Cloud Platform (GCP) para garantizar un despliegue óptimo y reproducible.

### **Recursos creados con Terraform**
- **Clúster de GKE**: Creación automática en la región y zona especificada.
- **Redes de VPC**: Configuración de subredes y reglas de firewall.
- **Artifact Registry**: Creación de un repositorio para almacenar los Helm Charts.
- **Cuentas de servicio**: Configuración de permisos como `roles/container.admin` y `roles/artifactregistry.writer`.

### **Pasos para usar Terraform**
1. Configurar variables en Terraform: Actualiza el archivo `terraform/terraform.tfvars` con la información específica de tu proyecto:

   ```hcl
   project_id     = "tu-proyecto-id"
   region         = "us-central1"
   cluster_name   = "mi-cluster"
   ```

2. Inicializar y aplicar Terraform: Ejecuta los siguientes comandos desde la carpeta terraform:

   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

# **Configuraciones necesarias en Google Cloud Platform (GCP)** 

1. Cuenta de servicio configurada con permisos adecuados:

- roles/container.admin
- roles/artifactregistry.writer
  
2. Credenciales de la cuenta de servicio: Descarga el archivo JSON de credenciales y conviértelo a base64. Configura el secreto como - - GCP_KEY en GitHub.

3. Habilitar APIs necesarias:

- Kubernetes Engine API
- Artifact Registry API

# **Configuración del clúster GKE**

- Un clúster de GKE creado y configurado en la región y zona deseadas.
- El clúster debe estar conectado al proyecto de GCP especificado.
  
# **Estructura del proyecto**

```plaintext
deploy_helm_chart/
├── .github/workflows/           # Configuración del pipeline CI/CD
│   └── deploy_helm_chart.yml    # Flujo automatizado de despliegue
├── templates/                   # Plantillas YAML de Kubernetes
│   ├── tests/                   # Pruebas automatizadas de Helm
│   ├── _helpers.tpl             # Funciones reutilizables para nombrado
│   ├── deployment.yaml          # Definición del despliegue
│   ├── hpa.yaml                 # Configuración de Horizontal Pod Autoscaler
│   ├── NOTES.txt                # Instrucciones post-despliegue
│   ├── serviceaccount.yaml      # Configuración de cuenta de servicio
│   ├── service.yaml             # Definición del servicio Kubernetes
├── terraform/                   # Configuración de Terraform para infraestructura
│   ├── .terraform/              # Archivos generados por Terraform
│   ├── helm_copy.sh             # Script opcional para integración Helm-Terraform
│   ├── main.tf                  # Configuración principal de Terraform
│   ├── outputs.tf               # Salidas generadas por Terraform
│   ├── terraform.tfstate        # Estado actual de la infraestructura
│   ├── terraform.tfstate.backup # Respaldo del estado
│   ├── variables.tf             # Variables de entrada para Terraform
├── charts/                      # Dependencias del Helm Chart
│   ├── common/                  # Subchart reutilizable
│   └── common-2.27.0.tgz        # Versión empaquetada del subchart
├── output/                      # Helm Charts empaquetados localmente
├── values.yaml                  # Configuraciones personalizables del Helm Chart
├── Chart.yaml                   # Metadata del Helm Chart
├── README.md                    # Documentación del proyecto
└── dummy.txt                    # Archivo de ejemplo para pruebas
```

# **Cómo ejecutar el proyecto**

1. Configurar secretos en GitHub Añade los siguientes secretos en tu repositorio:

- GCP_KEY: Credenciales de la cuenta de servicio en formato base64.
- PROJECT_ID: ID del proyecto de GCP.
- CLUSTER_NAME: Nombre del clúster de GKE.
- CLUSTER_LOCATION: Región o zona del clúster.

2. Clonar el repositorio Clona este repositorio en tu máquina local:

```bash
git clone https://github.com/tu_usuario/deploy_helm_chart.git
cd deploy_helm_chart
```

3. Ejecutar el pipeline en GitHub Actions El pipeline se activa automáticamente al realizar un push a la rama main. También puedes activarlo manualmente desde la pestaña Actions en GitHub.

4. Probar localmente (opcional)

- Actualizar dependencias de Helm:

```bash
helm dependency update
```

- Empaquetar el Helm Chart:

```bash
helm package . --destination ./output
```

- Probar el despliegue en tu clúster de GKE:

```bash
helm upgrade --install ping ./output/ping-0.1.0.tgz --namespace default
```

- Ejecutar pruebas automatizadas:

```bash
helm test ping --namespace default
```

# **Pruebas automatizadas**

El proyecto incluye un archivo de prueba que valida:

- Conectividad HTTP: Comprueba que el servicio responde correctamente.
- Resolución DNS: Asegura que el nombre DNS del servicio es válido.
- Disponibilidad del endpoint /health: Verifica su estado con curl.

Ejecuta las pruebas manualmente con:

```bash
helm test ping --namespace default
```

# **Manejo de errores comunes**

Error: Request entity too large

Aumenta el límite de tamaño en tu clúster GKE editando la configuración del servidor API:

```bash
kubectl edit cm kube-apiserver -n kube-system
```

Error: No such file or directory

Asegúrate de que las dependencias de Helm estén actualizadas y que el subchart common esté presente en la carpeta charts/:

```bash
helm dependency update
```

# **Mejores prácticas implementadas**

1. Reutilización de recursos existentes: Utiliza recursos compartidos (common) para garantizar la modularidad y evitar duplicaciones.
2. Gestión segura de credenciales: Se utiliza GitHub Secrets para manejar credenciales sensibles.
3. Compatibilidad de configuraciones: Todas las configuraciones son compatibles con Kubernetes y Helm v3.9+.
4. Pipeline automatizado: Proceso CI/CD que asegura la entrega continua y pruebas automatizadas.
5. Pruebas avanzadas: Validaciones de conectividad, disponibilidad y resolución DNS.
