pipeline {
    agent any

    environment {
        // Nombre de la imagen Docker
        IMAGE_NAME = "securedev-app"
        CONTAINER_NAME = "securedev-container"
    }

    stages {
        stage('Construcción') {
            steps {
                echo 'Construyendo la imagen Docker...'
                // Construye la imagen usando el Dockerfile
                sh 'docker build -t ${IMAGE_NAME}:latest .'
            }
        }

        stage('Pruebas') {
            steps {
                echo 'Ejecutando pruebas de sintaxis y seguridad base...'
                // Prueba simple para verificar que el código Python no tiene errores de sintaxis críticos
                sh 'python -m py_compile vulnerable_app.py'
                
                // Aquí es donde en el siguiente paso agregaremos la ejecución de OWASP ZAP y Dependabot
                echo 'Pruebas finalizadas con éxito.'
            }
        }

        stage('Despliegue') {
            steps {
                echo 'Desplegando la aplicación en el entorno de producción (Docker)...'
                // Detener y eliminar el contenedor anterior si existe (evita errores en despliegues continuos)
                sh '''
                    docker stop ${CONTAINER_NAME} || true
                    docker rm ${CONTAINER_NAME} || true
                '''
                // Levantar el nuevo contenedor en el puerto 5000
                sh 'docker run -d -p 5000:5000 --name ${CONTAINER_NAME} ${IMAGE_NAME}:latest'
            }
        }
    }
}