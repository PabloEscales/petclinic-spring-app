pipeline {
    agent any

    stages {
        stage('Git Checkout') {
            steps { 
                git branch: 'main', url: 'https://github.com/PabloEscales/petclinic-spring-app.git'
            }
        }

        stage('Maven') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Azure Service Princial login') {
            steps {
                withCredentials([azureServicePrincipal('poel-service-principal')]) {
                    sh 'az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET -t $AZURE_TENANT_ID'
                }
            }
        }

        stage('Docker login') {
            steps {
                sh 'sudo usermod -aG docker jenkins'
                sh 'newgrp docker'
                sh 'docker login acrDevopsPoel1.azurecr.io -u acrDevopsPoel1 -p XPfNs7vSlBl3tIgrlV8wVoPf6w6GNlCB4rKRxrN0uN+ACRDWlult'
            }
        }

              
        stage('Docker tag & build') {
            steps {
              sh 'docker build spring-openjdk:11'

              sh 'docker tag spring-openjdk:11 acrdevopspoel1.azurecr.io/spring-openjdk:11'
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
