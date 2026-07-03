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
                bat 'docker build -t %IMAGE_NAME%:latest .'
            }
        }

        stage('Pruebas') {
            steps {
                echo 'Ejecutando pruebas de sintaxis dentro del contenedor...'
                // Usamos docker run para que la prueba corra dentro de la imagen aislada
                bat 'docker run --rm %IMAGE_NAME%:latest python -m py_compile vulnerable_app.py'
                
                echo 'Pruebas finalizadas con éxito.'
            }
        }

        stage('Despliegue') {
            steps {
                echo 'Desplegando la aplicación en el entorno de producción (Docker)...'
                // Detener y eliminar el contenedor anterior si existe (evita errores en despliegues continuos)
                bat '''
                    docker stop %CONTAINER_NAME% || exit 0
                    docker rm %CONTAINER_NAME% || exit 0
                '''
                // Levantar el nuevo contenedor en el puerto 5000
                bat 'docker run -d -p 5000:5000 --name %CONTAINER_NAME% %IMAGE_NAME%:latest'
            }
        }
    }
}
