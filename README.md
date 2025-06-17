# Guvi-Project ReactJS CI/CD Pipeline with Jenkins, Docker, Security Scanning, and Monitoring

## 📘 Project Overview

This project demonstrates a complete CI/CD pipeline setup for a ReactJS frontend application using Jenkins Multibranch Pipelines. The pipeline is configured to automatically build, scan, and deploy Docker images whenever changes are pushed to the Git repository. It also includes monitoring and alerting using Prometheus, Alertmanager, and Grafana on AWS EC2.

---

## 🚀 Tech Stack

- **Frontend**: ReactJS
- **CI/CD**: Jenkins (Multibranch Pipeline)
- **Containerization**: Docker, Docker Compose
- **Code Quality**: SonarQube
- **Security Scans**: 
  - OWASP Dependency-Check (build-time dependency vulnerability scanner)
  - Trivy (Docker image vulnerability scanner)
- **Monitoring**: Prometheus, Alertmanager, Blackbox Exporter, Grafana
- **Infrastructure**: AWS EC2
- **Container Registry**: Docker Hub (Private & Public Repositories)

---

## 🌿 Git Branch Strategy

- **`main`**: For production builds. Docker images are pushed to a **private** Docker Hub repository.
- **`dev`**: For development builds. Docker images are pushed to a **public** Docker Hub repository.

---

## 🔧 Jenkins Setup and Configuration

### 1. Jenkins Installation

- Launch an **EC2 instance** (Ubuntu).
- Install Java, Jenkins, Docker, and required plugins:
  - Docker Pipeline
  - Git
  - Pipeline
  - OWASP Dependency-Check Plugin
  - SonarQube Scanner

### 2. Configure Jenkins:

- Add Docker Hub credentials (for private/prod repo).
- Add SonarQube server config under **Manage Jenkins → Configure System**.
- Add your GitHub repository as a Multibranch Pipeline Job.

### 3. Multibranch Pipeline Setup

- Configure Jenkins to scan the Git repository periodically (every 1 minute).
- Automatically detect changes on:
  - `main` branch → triggers `prod` pipeline
  - `dev` branch → triggers `dev` pipeline

---

## 🛠️ Project Structure

├── Jenkinsfile
├── build.sh # Builds Docker image
├── deploy.sh # Deploys Docker container to EC2
├── .gitignore
├── .dockerignore
├── docker-compose.yml
├── src/ # ReactJS source code
├── public/


---

## 🧪 Jenkins Pipeline Flow

### ✅ Steps Included in Pipeline

1. **Clone Repository**  
2. **SonarQube Analysis** (Code Quality)  
3. **OWASP Dependency-Check** (Library Vulnerabilities)  
4. **Build Docker Image** using `build.sh`  
5. **Scan Docker Image with Trivy**  
6. **Push Docker Image** to Docker Hub:  
   - `main` → Push to `prod` (private)  
   - `dev` → Push to `dev` (public)  
7. **Deploy Docker Container to EC2** using `deploy.sh`  
8. **Post-build Email Notification**:  
   - On **Success**: Send HTML reports  
   - On **Failure**: Send Jenkins build logs  

---

## 🛡️ Security Scanning Tools

- **Dependency-Check**:  
  - Scans project dependencies for known vulnerabilities  
  - Generates HTML report for email attachment  

- **Trivy**:  
  - Scans Docker images for OS/package vulnerabilities  
  - Generates HTML report for email on success  

---

## 🐳 Docker Image Management

- **Docker Compose** is used for local and EC2 deployments  
- Docker Hub Repositories:  
  - `prod`: Private repo (used for main branch)  
  - `dev`: Public repo (used for dev branch)  

---

## ☁️ AWS EC2 Setup for Deployment and Monitoring

### 1. EC2 Instance Setup

- Launch Ubuntu EC2 instance  
- Open all ports in the security group (for testing)  

### 2. Install Required Tools

Installing Docker:
sudo apt update
sudo apt install -y docker.io

Install Monitoring Stack:
    Prometheus
    Alertmanager
    Blackbox Exporter
    Grafana

Monitoring Flow:
    Prometheus scrapes Docker targets and Blackbox endpoints
    Alertmanager sends email if containers go down
    Grafana displays dashboards
    
🔔 Alerting Scenario:
    If a container (e.g., ReactJS app) goes down:
    Blackbox Exporter detects failed HTTP probe
    Prometheus triggers alert
    Alertmanager sends email notification
    
📬 Email Notification Configuration:
On Success:
    SonarQube quality result
    Dependency-Check HTML report
    Trivy Scan HTML report

On Failure:
    Jenkins console logs

pipeline {
    agent {
        docker {
            image 'your-docker-agent-image'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    environment {
        BRANCH_NAME = "${env.BRANCH_NAME}"
    }
    stages {
        stage('SonarQube Analysis') {
            ...
        }
        stage('Dependency Check') {
            ...
        }
        stage('Build Image') {
            steps {
                sh './build.sh'
            }
        }
        stage('Trivy Scan') {
            ...
        }
        stage('Push Image') {
            ...
        }
        stage('Deploy to EC2') {
            steps {
                sh './deploy.sh'
            }
        }
    }
    post {
        success {
            mail ...
        }
        failure {
            mail ...
        }
    }
}

📌 Conclusion
This project ensures:

   Automated code build and deployment.
   Secure code and container image analysis.
   Real-time monitoring and alerting.
   Efficient branch-based CI/CD workflows.
   Complete DevSecOps implementation for ReactJS.

🔐 Notes
Docker Hub credentials securely stored in Jenkins Credentials.
Jenkins pipeline runs in Docker agents.
Email setup required for sending notifications.
EC2 instance configured for container deployments and monitoring.





