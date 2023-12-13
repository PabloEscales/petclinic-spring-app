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
    }
}
