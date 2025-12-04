pipeline {
    agent {
        docker { 
            image 'node:20-alpine' 
            args '--privileged -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        IMAGE_NAME = "richardchesterwood/k8s-fleetman-webapp-angular"
        IMAGE_TAG = "release2"
        SONARQUBE = "SonarQube" // Nom du serveur SonarQube configuré dans Jenkins
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

        stage('Build Angular') {
            steps {
                echo 'Building Angular apps...'
                sh 'npm install'
                sh 'npm install -g @angular/cli'
                sh 'ng build --prod --projects app1'
                sh 'ng build --prod --projects app2'
                // ajouter d'autres apps si nécessaire
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Test & SonarQube Analysis') {
            steps {
                echo 'Running tests and SonarQube scan...'
                withSonarQubeEnv("${SONARQUBE}") {
                    sh "ng test --watch=false --browsers=ChromeHeadless"
                    sh "sonar-scanner -Dsonar.projectKey=my-angular-app -Dsonar.sources=src -Dsonar.host.url=$SONAR_HOST_URL -Dsonar.login=$SONAR_AUTH_TOKEN"
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
            }
        }

    }

    post {
        success {
            echo "Pipeline finished successfully ✅"
        }
        failure {
            echo "Pipeline failed ❌"
        }
        always {
            echo "Pipeline run completed."
        }
    }
}

