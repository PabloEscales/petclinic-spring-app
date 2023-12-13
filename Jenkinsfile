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
    }
}
