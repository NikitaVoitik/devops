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
        stage('Setup') {
            steps {
                sh '''
                    if ! command -v docker &> /dev/null; then
                        echo "Installing Docker..."
                        # Add Docker installation commands for your OS
                        curl -fsSL https://get.docker.com -o get-docker.sh
                        sh get-docker.sh
                    fi
                '''
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
                    keyFileVariable: 'ssh_key',
                    usernameVariable: 'ssh_user')]) {
                        sh """
chmod +x main

mkdir -p ~/.ssh
ssh-keyscan target >> ~/.ssh/known_hosts

ssh -i ${ssh_key} laborant@target 'sudo systemctl stop main.service || true'

ssh -i ${ssh_key} laborant@target 'docker stop app_container || true && docker rm app_container || true'

ssh -i ${ssh_key} laborant@target 'docker pull ttl.sh/main.app:2h'

ssh -i ${ssh_key} laborant@target 'sudo mv /home/laborant/main.service /etc/systemd/system/main.service'

ssh -i ${ssh_key} laborant@target 'sudo mv /home/laborant/main /opt/main'

ssh -i ${ssh_key} laborant@target 'sudo systemctl daemon-reload'

ssh -i ${ssh_key} laborant@target 'docker run -p 4444:4444 --name app_container ttl.sh/main.app:2h'
"""
                }
            }
        }
    }
}
