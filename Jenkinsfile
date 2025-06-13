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

        stage('Static Code Analysis') {
            environment {
                SONAR_URL = "http://192.168.0.180:9000"
            }
            steps {
                withCredentials([string(credentialsId: 'sonarqube', variable: 'SONAR_AUTH_TOKEN')]) {
                    sh '''
                        cd Guvi-Project-1/build
                        sonar-scanner -Dsonar.projectKey=Guvi-Project-1 -Dsonar.sources=. -Dsonar.host.url=${SONAR_URL} -Dsonar.login=${SONAR_AUTH_TOKEN}
                    '''
                }
            }
        }
    }
}
