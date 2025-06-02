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
                sh "docker push ttl.sh/main.app:2h"
            }
        }
        stage('Login') {
            steps {
                withCredentials([sshUserPrivateKey(
                    credentialsId: '485e9257-7c6e-411e-9487-267a87234a20',
                    keyFileVariable: 'ssh_key',
                    usernameVariable: 'ssh_user')]) {
                        sh """
                            mkdir -p ~/.ssh
                            ssh-keyscan docker >> ~/.ssh/known_hosts
                           """
                }
            }
        }
        stage('Deploy Kubernetes') {
            withKubeConfig([credentialsId: 'user1', serverUrl: 'https://k8s:6443']) {
                sh 'kubectl apply -f pod.yaml'
                sh 'kubectl wait --for=condition=Ready pod/myapp --timeout=120s'
                sh 'kubectl apply -f service.yaml'
                sh 'kubectl get svc myapp-service -o wide'
            }
        }
    }
}
