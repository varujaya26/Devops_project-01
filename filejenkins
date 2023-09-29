pipeline {
    agent any

    stages {
        stage('SCM') {
            steps {
                git branch: 'war', url: 'https://github.com/varujaya26/docker-deployment.git'
            }
        }
        stage('BUILD') {
            steps {
                sh 'mvn clean'
                sh 'mvn install'
            }
        }
        stage('BUILD DOCKER IMAGE'){
            steps {
                script {
                    app = docker.build("varujaya26/demo")
                    app.inside {
                        sh 'echo $(curl http://localhost:8080)'
                    }
                }
            }
        }
        stage('PUSH TO HUB') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub') {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }
        stage('DeployToDEV') {

            steps {
                input 'Deploy to Dev?'
                milestone(1)
                withCredentials([usernamePassword(credentialsId: 'dev', usernameVariable: 'USERNAME', passwordVariable: 'USERPASS')]) {
                    script {
                        sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip1 \"docker pull varujaya26/demo:${env.BUILD_NUMBER}\""
                        try {
                            sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip1 \"docker stop azcs\""
                            sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip1 \"docker rm azcs\""
                        } catch (err) {
                            echo: 'caught error: $err'
                        }
                        sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip1 \"docker run --restart always --name azcs -p 8080:8080 -d varujaya26/demo:${env.BUILD_NUMBER}\""
                    }
                }
            }
        }
        stage('DeployToTEST') {

            steps {
                input 'Deploy to TEST?'
                milestone(2)
                withCredentials([usernamePassword(credentialsId: 'test', usernameVariable: 'USERNAME', passwordVariable: 'USERPASS')]) {
                    script {
                        sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip2 \"docker pull varujaya26/demo:${env.BUILD_NUMBER}\""
                        try {
                            sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip2 \"docker stop azcs\""
                            sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip2 \"docker rm azcs\""
                        } catch (err) {
                            echo: 'caught error: $err'
                        }
                        sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip2 \"docker run --restart always --name azcs -p 8080:8080 -d varujaya26/demo:${env.BUILD_NUMBER}\""
                    }
                }
            }
        }
        stage('DeployToPROD') {

            steps {
                input 'Deploy to Prod?'
                milestone(3)
                withCredentials([usernamePassword(credentialsId: 'prod', usernameVariable: 'USERNAME', passwordVariable: 'USERPASS')]) {
                    script {
                        sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip3 \"docker pull varujaya26/demo:${env.BUILD_NUMBER}\""
                        try {
                            sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip3 \"docker stop azcs\""
                            sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip3 \"docker rm azcs\""
                        } catch (err) {
                            echo: 'caught error: $err'
                        }
                        sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip3 \"docker run --restart always --name azcs -p 8080:8080 -d varujaya26/demo:${env.BUILD_NUMBER}\""
                    }
                }
            }
        }
    }
}
