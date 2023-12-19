pipeline {
    agent any
 
    stages {
        stage('Git Checkout') {
            steps { 
                git branch: 'main', url: 'https://github.com/PabloEscales/petclinic-spring-app.git'
            }
        }

        stage('Build Maven') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Azure Service Principal login') {
            steps {
                withCredentials([azureServicePrincipal('poel-service-principal')]) {
                    sh 'az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET -t $AZURE_TENANT_ID'
                }
            }
        }

        stage('Docker Permissions') {
            steps {
                script {
                    sh 'sudo usermod -aG docker jenkins
                    sh 'sudo chown :docker /var/run/docker.sock
                    sh 'sudo chmod 660 /var/run/docker.sock
                }
            }
        }

        stage('Docker login') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'acrDocker', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        def dockerLoginCmd = "echo \$DOCKER_PASS | docker login acrDevopsPoel1.azurecr.io -u \$DOCKER_USER --password-stdin"
                        sh dockerLoginCmd
                    }
                }
            }
        }

        stage('Docker tag & build') {
            steps {
                sh 'docker build -t spring-openjdk:11 .'
                sh 'docker tag spring-openjdk:11 acrDevopsPoel1.azurecr.io/spring-openjdk:11'
            }
        }

        stage('ACR login & push') {
            steps {
                sh 'az acr login --name acrDevopsPoel1'
                sh 'docker push acrDevopsPoel1.azurecr.io/spring-openjdk:11'
            }
        }
    }
}
