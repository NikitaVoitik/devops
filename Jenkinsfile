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
        stage('Build') {
            steps {
                echo 'Building...'
                // Add your build steps here
            }
        }
    }
}
