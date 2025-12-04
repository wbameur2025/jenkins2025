pipeline {
    agent any  // Jenkins utilisera l'agent par défaut, pas besoin de Node

    environment {
        IMAGE_NAME = "richardchesterwood/k8s-fleetman-webapp-angular"
        IMAGE_TAG = "release2"
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
                script {
                    commit_id = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                }
                echo "Commit ID: ${commit_id}"
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
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
            echo "Pipeline finished successfully... "
        }
        failure {
            echo "Pipeline failed..."
        }
        always {
            echo "Pipeline run completed."
        }
    }
}

