pipeline {
    agent any

    tools {
        go "1.24.1"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Dependencies') {
            steps {
                sh 'go mod tidy'
                sh 'go mod download'
            }
        }
        stage('Test') {
            steps {
                sh "go test ./app/..."
            }
        }
        stage('Build') {
            steps {
                sh "docker build . --tag ttl.sh/main.app:2h"

            }
        }
        stage('Deploy') {
            steps {
                sh "docker push ttl.sh/main.app:2h"
                withCredentials([sshUserPrivateKey(
                    credentialsId: '485e9257-7c6e-411e-9487-267a87234a20',
                    keyFileVariable: 'DevOps',
                    usernameVariable: 'ec2_user')]) {
                        sh """
mkdir -p ~/.ssh
ssh-keyscan docker >> ~/.ssh/known_hosts

ssh -i ${ssh_key} ec2-user@ec2-18-197-32-2.eu-central-1.compute.amazonaws.com 'sudo systemctl stop main.service || true'

ssh -i ${ssh_key} ec2-user@ec2-18-197-32-2.eu-central-1.compute.amazonaws.com 'docker stop app_container || true && docker rm app_container || true'

ssh -i ${ssh_key} ec2-user@ec2-18-197-32-2.eu-central-1.compute.amazonaws.com 'docker pull ttl.sh/main.app:2h'

ssh -i ${ssh_key} ec2-user@ec2-18-197-32-2.eu-central-1.compute.amazonaws.com 'docker run -d -p 4444:4444 --name app_container ttl.sh/main.app:2h'
"""
                }
            }
        }
    }
}
