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
                sh "go build app/main.go"
            }
        }
        stage('Deploy') {
            steps {
                withCredentials([sshUserPrivateKey(
                    credentialsId: '485e9257-7c6e-411e-9487-267a87234a20',
                    keyFileVariable: 'ssh_key',
                    usernameVariable: 'ssh_user')]) {
                        sh """
chmod +x main

mkdir -p ~/.ssh
ssh-keyscan target >> ~/.ssh/known_hosts

ssh -i ${ssh_key} laborant@target 'sudo systemctl stop main.service'

scp -i ${ssh_key} main ${ssh_user}@target:

scp -i ${ssh_key} main.service ${ssh_user}@target:

ssh -i ${ssh_key} laborant@target 'sudo mv /home/laborant/main.service /etc/systemd/system/main.service'

ssh -i ${ssh_key} laborant@target 'sudo mv /home/laborant/main /opt/main'

ssh -i ${ssh_key} laborant@target 'sudo systemctl daemon-reload'

ssh -i ${ssh_key} laborant@target 'sudo systemctl enable --now main.service'
"""
                }
            }
        }
    }
}
