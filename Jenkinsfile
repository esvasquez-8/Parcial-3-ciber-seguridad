pipeline {
    agent any

    environment {
        IMAGE_NAME = "securedev-app"
        CONTAINER_NAME = "securedev-container"
    }

    stages {
        stage('Construcción') {
            steps {
                echo 'Construyendo la imagen Docker...'
                bat 'docker build -t %IMAGE_NAME%:latest .'
            }
        }

        stage('Pruebas Básicas') {
            steps {
                echo 'Ejecutando pruebas de sintaxis dentro del contenedor...'
                bat 'docker run --rm %IMAGE_NAME%:latest python -m py_compile vulnerable_app.py'
                echo 'Pruebas finalizadas con éxito.'
            }
        }

        stage('Despliegue') {
            steps {
                echo 'Desplegando la aplicación en el entorno de producción (Docker)...'
                bat '''
                    docker stop %CONTAINER_NAME% || exit 0
                    docker rm %CONTAINER_NAME% || exit 0
                '''
                bat 'docker run -d -p 5000:5000 --name %CONTAINER_NAME% %IMAGE_NAME%:latest'
            }
        }

        stage('Análisis de Seguridad (ZAP)') {
            steps {
                echo 'Iniciando escaneo automatizado con OWASP ZAP...'
                bat '''
                    docker pull zaproxy/zap-stable
                    docker run --rm -v "%CD%:/zap/wrk/:rw" zaproxy/zap-stable zap-baseline.py -t http://host.docker.internal:5000 -I -r zap_report.html
                '''
                echo 'Escaneo ZAP completado. Reporte generado.'
            }
        }
    }
}
