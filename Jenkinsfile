pipeline {
    agent {
        docker {
            image 'kdilipkumar/jenkins-agent:v19'
            args '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        DOCKER_IMAGE = "kdilipkumar/backend:v${env.BUILD_NUMBER}"
        DOCKER_IMAGE_NAME = "guvi-project-1"
        DOCKER_VERSION = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Cleanup') {
            steps {
                sh 'rm -rf Guvi-Project-1 || true'
            }
        }

        stage('Checkout Repository') {
            steps {
                sh '''
                    echo "Cloning repository..."
                    git clone https://github.com/Dilip-Devopos/Guvi-Project-1.git
                '''
            }
        }

        stage('Setup & Build Web') {
            steps {
                sh '''
                cd Guvi-Project-1
                chmod +x build.sh
                build.sh DOCKER_IMAGE_NAME=${DOCKER_IMAGE_NAME} DOCKER_VERSION=${DOCKER_VERSION}
                '''
            }
        }
    }
    post {
        success {
            emailext(
                subject: "SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: "Good news!\n\nThe Jenkins job '${env.JOB_NAME}' completed successfully.\nBuild URL: ${env.BUILD_URL}",
                to: "dilipbca99@gmail.com"
            )
        }

        failure {
            emailext(
                subject: "FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: "Unfortunately, the Jenkins job '${env.JOB_NAME}' has failed.\nBuild URL: ${env.BUILD_URL}",
                to: "dilipbca99@gmail.com"
            )
        }
    }

}
