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
                        mvn sonar:sonar -Dsonar.login=$SONAR_AUTH_TOKEN -Dsonar.host.url=${SONAR_URL}
                    '''
                }
            }
        }

        stage('OWASP Dependency-Check Vulnerabilities') {
            steps {
                script {
                    sh '''
                        /opt/dependency-check/bin/dependency-check.sh \
                        --project "Guvi-Project-1" \
                        --scan /var/lib/jenkins/workspace/Guvi/Guvi-Project-1/build/* \
                        --out dependency-check-reports \
                        --format "XML"
                    '''
                    sh 'chown -R jenkins:jenkins dependency-check-reports'
                    sh 'chmod 644 dependency-check-reports/*.xml'
                    sh 'ls -la dependency-check-reports'
                }
                dependencyCheckPublisher pattern: 'dependency-check-reports/*.xml'
            }
        }


        stage('Build & Tag') {
            steps {
                dir('Guvi-Project-1') {
                    sh "./build.sh ${IMAGE_NAME} ${VERSION} ${BRANCH_NAME}"
                }
            }
        }
        
        stage('Prepare Docker Image Name') {
            steps {
                script {
                    def repo = (env.BRANCH_NAME == "main") ? "kdilipkumar/prod" : "kdilipkumar/dev"
                    env.dockerimage = "${repo}:${VERSION}"
                }
            }
        }
        
        stage('Security Scan with Trivy') {
            steps {
                script {
                    sh '''
                        echo "Running Trivy vulnerability scan..."
                        trivy --version
                        trivy image --severity HIGH,CRITICAL ${dockerimage}
                    '''
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    def repo = (env.BRANCH_NAME == "main") ? "kdilipkumar/prod" : "kdilipkumar/dev"
                    def dockerimage = "${repo}:${VERSION}"

                    docker.withRegistry('https://index.docker.io/v1/', 'docker-cred') {
                        sh "docker push ${dockerimage}"
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
