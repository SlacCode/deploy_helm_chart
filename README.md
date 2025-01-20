# **Deploy Helm Chart to GKE**

Este proyecto permite desplegar un Helm Chart en un clúster de Google Kubernetes Engine (GKE) utilizando GitHub Actions y Terraform. Ofrece un pipeline CI/CD completo con autenticación segura, gestión de dependencias y pruebas automatizadas, además de infraestructura declarativa para la creación y configuración de los recursos necesarios.

### **Requisitos previos**

Antes de ejecutar este proyecto, asegúrate de cumplir con los siguientes requisitos:

### **Herramientas necesarias**

- Git
- Helm v3.9+
- kubectl
- Google Cloud SDK
- Terraform

### **Configuraciones necesarias en Google Cloud Platform (GCP)**

1. Cuenta de servicio configurada con permisos adecuados:

- roles/container.admin
- roles/artifactregistry.writer
- Credenciales de la cuenta de servicio: Descarga el archivo JSON de credenciales y conviértelo a base64. Configura el secreto como GCP_KEY en GitHub.
  
### **Estructura del proyecto**

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

### **Cómo ejecutar el proyecto**

1. Configurar secretos en GitHub. 

Añade los siguientes secretos en tu repositorio:

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

### **Soluciones por ejercicio**

Reto 1: Despliegue en GKE

- El despliegue del Helm Chart en un clúster de GKE se realiza mediante un pipeline CI/CD automatizado. La configuración está en .github/workflows/deploy_helm_chart.yml.
- Los recursos definidos incluyen configuraciones para deployment.yaml, service.yaml, y otras plantillas Helm.

Reto 2: Infraestructura declarativa

- Herramienta utilizada: Terraform.
- La configuración de Terraform está incluida en la carpeta terraform/. Los archivos main.tf, variables.tf, y outputs.tf automatizan la creación del clúster de GKE, redes VPC y cuentas de servicio.

Reto 3: Pipeline CI/CD

- Integración de Terraform: El pipeline ejecuta terraform init y terraform apply antes del despliegue de Helm.
- Integración de Helm: Se actualizan dependencias, se empaqueta el Helm Chart, y se despliega automáticamente en el clúster de GKE.

### **Pruebas automatizadas**

El proyecto incluye un archivo de prueba (templates/tests/) que valida:

1. Conectividad HTTP: Comprueba que el servicio responde correctamente.
2. Resolución DNS: Asegura que el nombre DNS del servicio es válido.
3. Disponibilidad del endpoint /health: Verifica su estado.

Ejecuta las pruebas manualmente con:

```bash
helm test ping --namespace default
```

### **Pruebas automatizadas**

Error: No such file or directory

Asegúrate de que las dependencias de Helm estén actualizadas y que el subchart common esté presente en la carpeta charts/:

```bash
helm dependency update
```

### **Manejo de errores comunes**

Error: Request entity too large

- Aumenta el límite de tamaño en el servidor API de Kubernetes:
  
```bash
kubectl edit cm kube-apiserver -n kube-system
```

Agrega:

```bash
--max-request-bytes=6291456
```

Error: No such file or directory

- Solución:
  
```bash
helm dependency update
```

### **Mejores prácticas implementadas**

1. Reutilización de recursos existentes: Se utiliza el subchart common para evitar duplicación de recursos.
2. Gestión segura de credenciales: Uso de GitHub Secrets para credenciales sensibles.
3. Infraestructura declarativa: Configuración de infraestructura con Terraform.
4. Pipeline CI/CD: Automatización del despliegue con GitHub Actions.
5. Pruebas automatizadas: Validaciones completas del despliegue y conectividad.