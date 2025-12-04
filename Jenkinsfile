pipeline {
    agent any  // Jenkins utilisera l'agent par défaut

    environment {
        IMAGE_NAME = "richardchesterwood/k8s-fleetman-webapp-angular"
        IMAGE_TAG = "release2"
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
                script {
                    // Utilisation de 'def' pour éviter le warning Jenkins
                    def commit_id = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    echo "Commit ID: ${commit_id}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('SonarQube Analysis') {
            steps {
                echo "Running SonarQube analysis..."
                // 'SonarQube' : nom du serveur défini dans Jenkins
                withSonarQubeEnv('SonarQube') {
                    sh """
                        sonar-scanner \
                        -Dsonar.projectKey=my-angular-app \
                        -Dsonar.sources=src \
                        -Dsonar.host.url=$SONAR_HOST_URL \
                        -Dsonar.login=$SONAR_AUTH_TOKEN
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo 'Deploying to Kubernetes...'
                sh """
                sed -i 's|image:.*|image: ${IMAGE_NAME}:${IMAGE_TAG}|' manifests/workloads.yaml
                kubectl apply -f manifests/
                kubectl get pods
                """
            }
        }

    }

    post {
        success {
            echo "Pipeline finished successfully "
        }
        failure {
            echo "Pipeline failed.. "
        }
        always {
            echo "Pipeline run completed."
        }
    }
}

