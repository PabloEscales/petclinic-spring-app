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
                withCredentials([azureServicePrincipal('poel-service-principal')]) {
                    sh 'docker login acrDevopsPoel1.azurecr.io -u $ID_DEL_SERVICE_PRINCIPAL -p $SECRET_DEL_SERVICE_PRINCIPAL'
                }           
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
                sh 'az acr login --name acrdevopspoel1'       

                sh 'docker push acrdevopspoel1.azurecr.io/spring-openjdk'
            }
        }
    }
}
