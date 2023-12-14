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
                withCredentials([usernamePassword(credentialsId: 'eb72bbbc-c0e2-4aa3-ada1-6630e1363a96', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'docker login acrDevopsPoel1.azurecr.io -u $DOCKER_USER -p $DOCKER_PASS'
                    // script {
                    //     def dockerLoginCmd = "echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin acrDevopsPoel1.azurecr.io"
                    //     sh dockerLoginCmd
                    // }
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
                sh 'az acr login --name acrDevopsPoel1'       

                sh 'docker push acrDevopsPoel1.azurecr.io/spring-openjdk:11'
            }
        }
    }
}
