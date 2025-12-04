pipeline {

    agent any

    environment {
        IMAGE_NAME = "richardchesterwood/k8s-fleetman-webapp-angular"
        IMAGE_TAG = "release2"
        SONARQUBE = "SonarQube" // nom du serveur SonarQube configuré dans Jenkins
    }

    stages {

        stage('Preparation') {
            steps {
                checkout scm
                script {
                    commit_id = sh(
                        script: "git rev-parse --short HEAD",
                        returnStdout: true
                    ).trim()
                }
                echo "Commit ID: ${commit_id}"
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                echo 'Docker build complete ✅'
            }
        }

        stage('Test & SonarQube Analysis') {
            steps {
                echo 'Running tests and SonarQube scan...'
                withSonarQubeEnv("${SONARQUBE}") {
                    // Exemple pour un projet Angular
                    sh "npm install"
                    sh "ng test --watch=false --browsers=ChromeHeadless"
                    sh "sonar-scanner \
                        -Dsonar.projectKey=my-angular-app \
                        -Dsonar.sources=src \
                        -Dsonar.host.url=$SONAR_HOST_URL \
                        -Dsonar.login=$SONAR_AUTH_TOKEN"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo 'Deploying to Kubernetes...'
                sh """
                sed -i 's|image:.*|image: ${IMAGE_NAME}:${IMAGE_TAG}|' .manifests/workloads.yaml
                kubectl apply -f .manifests/
                kubectl get pods
                """
                echo 'Deployment complete ✅'
            }
        }

    }

    post {
        always {
            echo "Pipeline finished."
        }
    }

}

 
