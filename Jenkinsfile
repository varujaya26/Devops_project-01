pipeline {
    agent { label 'slave-01' }

    stages {
        stage('SCM') {
            steps {
                git branch: 'war', url: 'https://github.com/varujaya26/Devops_project-01.git'
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
                    app = docker.build("varujaya26/project01")
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
    }
}
