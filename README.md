# **Deploy Helm Chart to GKE**

Este proyecto permite desplegar un Helm Chart en un clúster de Google Kubernetes Engine (GKE) utilizando GitHub Actions. Proporciona un pipeline CI/CD completo con autenticación segura, gestión de dependencias y pruebas automatizadas.

## **Requisitos previos**

Antes de ejecutar este proyecto, asegúrate de cumplir con los siguientes requisitos:

### **Herramientas necesarias:**
- [Git](https://git-scm.com/)
- [Helm v3.9+](https://helm.sh/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)

### **Configuraciones necesarias en Google Cloud Platform (GCP):**
1. **Cuenta de servicio** configurada con permisos adecuados:
   - `roles/container.admin`
   - `roles/artifactregistry.writer`
2. **Credenciales de la cuenta de servicio:** Descarga el archivo JSON de credenciales y conviértelo a base64. Configura el secreto como `GCP_KEY` en GitHub.
3. **Habilitar APIs necesarias:**
   - Kubernetes Engine API
   - Artifact Registry API

### **Configuración del clúster GKE:**
- Un clúster de GKE creado y configurado en la región y zona deseadas.
- El clúster debe estar conectado al proyecto de GCP especificado.

## **Estructura del proyecto**

```plaintext
deploy_helm_chart/
├── .github/workflows/           # Pipeline CI/CD
│   └── deploy_helm_chart.yml    # Configuración del flujo de trabajo
├── templates/                   # Plantillas YAML de Kubernetes
│   ├── tests/                   # Pruebas automatizadas de Helm
│   └── ...                      # Recursos como deployments, services, etc.
├── values.yaml                  # Configuraciones personalizables
├── Chart.yaml                   # Metadata del Helm Chart
└── README.md                    # Documentación del proyecto
```

## **Cómo ejecutar el proyecto**
1. Configurar secretos en GitHub
- Añade los siguientes secretos en tu repositorio:

- GCP_KEY: Credenciales de la cuenta de servicio en formato base64.
- PROJECT_ID: ID del proyecto de GCP.
- CLUSTER_NAME: Nombre del clúster de GKE.
- CLUSTER_LOCATION: Región o zona del clúster.

2. Clonar el repositorio
Clona este repositorio en tu máquina local:

- git clone https://github.com/tu_usuario/deploy_helm_chart.git
- cd deploy_helm_chart

3. Ejecutar el pipeline en GitHub Actions
- El pipeline se activa automáticamente al realizar un push a la rama main. También puedes activarlo manualmente desde la pestaña Actions en GitHub.

4. Probar localmente (opcional)
- Si deseas probar el despliegue localmente antes de ejecutar el pipeline:

## **Actualizar dependencias de Helm**
helm dependency update

## **Empaquetar el Helm Chart**
helm package . --destination ./output

## **Probar el despliegue en tu clúster de GKE**
helm upgrade --install ping ./output/ping-0.1.0.tgz --namespace default

## **Ejecutar pruebas automatizadas**
helm test ping --namespace default

## **Pruebas automatizadas**
- El proyecto incluye un archivo de prueba que valida:

- Conectividad HTTP: Comprueba que el servicio responde correctamente.
- Resolución DNS: Asegura que el nombre DNS del servicio es válido.
- Disponibilidad del endpoint /health: Verifica su estado con curl.

## **Ejecuta las pruebas manualmente con:**
helm test ping --namespace default

## **Manejo de errores comunes**
- Error: Request entity too large

- Aumenta el límite de tamaño en tu clúster GKE editando la configuración del servidor API:
- kubectl edit cm kube-apiserver -n kube-system

## **Agrega '--max-request-bytes=6291456' en la configuración**
Error: No such file or directory

- Asegúrate de que las dependencias de Helm estén actualizadas y que el subchart common esté presente en la carpeta charts/:
helm dependency update

## **Mejores prácticas implementadas**
1. Reutilización de recursos existentes: Utiliza recursos compartidos (common) para garantizar la modularidad y evitar duplicaciones.
2. Gestión segura de credenciales: Se utiliza GitHub Secrets para manejar credenciales sensibles.
3. Compatibilidad de configuraciones: Todas las configuraciones son compatibles con Kubernetes y Helm v3.9+.
4. Pipeline automatizado: Proceso CI/CD que asegura la entrega continua y pruebas automatizadas.
5. Pruebas avanzadas: Validaciones de conectividad, disponibilidad y resolución DNS.