pipeline {
    agent any

    triggers {
        pollSCM('* * * * *') // Optional for polling
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
    }
}
