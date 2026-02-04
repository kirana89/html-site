@Library("Shared") _
pipeline {
    agent {label "kiran"}
    
    triggers {
        githubPush()
    }
    stages {
        stage("Hello"){
            steps{
                script{
                    hello()
                }
            }
        }
        stage('Clone Code') {
            steps {
                echo "Cloning repository..."
                git url: 'https://github.com/kirana89/html-site.git', branch: 'main'
                echo "Code cloned successfully."
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh "docker build -t simple-webpage:latest ."
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo "Pushing Docker image to Docker Hub..."
                withCredentials([usernamePassword(credentialsId: 'dockerhubcred', usernameVariable: 'dockerHubUser', passwordVariable: 'dockerHubPass')]) {
                    sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPass}"
                    sh "docker tag simple-webpage:latest ${env.dockerHubUser}/simple-webpage:latest"
                    sh "docker push ${env.dockerHubUser}/simple-webpage:latest"
                }
                echo "Docker image pushed successfully."
            }
        }

        stage('Deploy') {
            steps {
                echo "Deploying Docker container..."
                // Stop existing container if running
                sh '''
                if [ $(docker ps -q -f name=simple-webpage) ]; then
                    docker stop simple-webpage
                    docker rm simple-webpage
                fi
                '''
                // Pull latest image
                withCredentials([usernamePassword(credentialsId: 'dockerhubcred', usernameVariable: 'dockerHubUser', passwordVariable: 'dockerHubPass')]) {
                    sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPass}"
                      sh "docker pull ${env.dockerHubUser}/simple-webpage:latest"
                // Run container
                sh "docker run -d --name simple-webpage -p 8080:80 ${env.dockerHubUser}/simple-webpage:latest"
                }
                //sh "docker pull ${env.dockerHubUser}/simple-webpage:latest"
                // Run container
                //sh "docker run -d --name simple-webpage -p 8080:80 ${env.dockerHubUser}/simple-webpage:latest"
                echo "Deployment completed. Visit http://your-server-ip:8080"
            }
        }
    }
}
