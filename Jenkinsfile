pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building..'
                echo $sha1
                echo $ghprbSourceBranch
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}