pipeline {
    agent {
        docker {
            image 'kdilipkumar/jenkins-agent:v19'
            args '--user root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        IMAGE_NAME = "guvi-project-1"
        VERSION = "${env.BUILD_NUMBER}"
        REGISTRY_CREDENTIALS = credentials('docker-cred')
    }

    stages {
        stage('Cleanup') {
            steps {
                sh 'rm -rf Guvi-Project-1 || true'
            }
        }

        stage('Clone Repository') {
            steps {
                sh '''
                    echo "Cloning repository..."
                    git clone https://github.com/Dilip-Devopos/Guvi-Project-1.git
                '''
            }
        }

        stage('Build & Tag') {
            steps {
                dir('Guvi-Project-1') {
                    sh "./build.sh ${IMAGE_NAME} ${VERSION} ${BRANCH_NAME}"
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    // Dynamically determine which repo was used
                    def repo = (env.BRANCH_NAME == "main") ? "kdilipkumar/guvi-prod" : "kdilipkumar/guvi-dev"
                    def fullImage = "${repo}:${VERSION}"

                    docker.withRegistry('https://index.docker.io/v1/', REGISTRY_CREDENTIALS) {
                        sh "docker push ${fullImage}"
                    }
                }
            }
        }
    }

    post {
        success {
            emailext(
                subject: "SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: "Good news!\n\nThe Jenkins job '${env.JOB_NAME}' completed successfully.\nBuild URL: ${env.BUILD_URL}",
                to: "your_email@example.com"
            )
        }

        failure {
            emailext(
                subject: "FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: "Unfortunately, the Jenkins job '${env.JOB_NAME}' has failed.\nBuild URL: ${env.BUILD_URL}",
                to: "your_email@example.com"
            )
        }
    }
}
