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
        DEV_REPO = "kdilipkumar/guvi-dev"
        PROD_REPO = "kdilipkumar/guvi-prod"
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
                    sh '''
                        chmod +x build.sh
                        if [ "${BRANCH_NAME}" == "main" ]; then
                            ./build.sh ${IMAGE_NAME} ${VERSION} ${PROD_REPO}
                        else
                            ./build.sh ${IMAGE_NAME} ${VERSION} ${DEV_REPO}
                        fi
                    '''
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-cred') {
                        if (env.BRANCH_NAME == 'main') {
                            sh "docker push ${PROD_REPO}:${VERSION}"
                        } else {
                            sh "docker push ${DEV_REPO}:${VERSION}"
                        }
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
                to: ""
            )
        }

        failure {
            emailext(
                subject: "FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: "Unfortunately, the Jenkins job '${env.JOB_NAME}' has failed.\nBuild URL: ${env.BUILD_URL}",
                to: ""
            )
        }
    }

}
