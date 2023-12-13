pipeline {
    agent any

    stages {
        stage('Git Checkout') {
            steps { 
                git branch: 'main', url: 'https://github.com/PabloEscales/iac-petclinic.git'
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
               sh 'docker login acrdevopspoel1.azurecr.io -u ba6d6ba8-c858-45bb-bd2f-cbf93501f95f -p "YU58Q~yU_RxD-wz7swIJ2-XmY4_Evkl7IX5eddqN"'        
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

                sh 'az login --service-principal -u ba6d6ba8-c858-45bb-bd2f-cbf93501f95f -p "YU58Q~yU_RxD-wz7swIJ2-XmY4_Evkl7IX5eddqN" --tenant b91b4c46-c3c5-4a82-be1c-6009b3002444'

                sh 'docker push acrdevopspoel1.azurecr.io/spring-openjdk'
            }
        }
    }
}
