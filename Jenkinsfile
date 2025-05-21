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
