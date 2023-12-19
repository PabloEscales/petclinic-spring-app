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
                    sh 'sudo usermod -aG docker jenkins'
                    sh 'sudo chown :docker /var/run/docker.sock'
                    sh 'sudo chmod 666 /var/run/docker.sock'
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
                sh 'az acr login --name acrDevopsPoel1 -u ba6d6ba8-c858-45bb-bd2f-cbf93501f95f -p eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlNXUVk6VFFVSjpWSEZIOkFETjU6T1JTTzpIRks1OlZDWEg6NTNPTjpBTkNUOjJQMjI6MzRBQjpUVzVPIn0.eyJqdGkiOiI3Y2EwZjY4My03MmFlLTRjN2QtOWQ3NS1jZmFhYmRlZmU1MTkiLCJzdWIiOiJwb2VsQGdmdC5jb20iLCJuYmYiOjE3MDI5OTg0ODUsImV4cCI6MTcwMzAxMDE4NSwiaWF0IjoxNzAyOTk4NDg1LCJpc3MiOiJBenVyZSBDb250YWluZXIgUmVnaXN0cnkiLCJhdWQiOiJhY3JkZXZvcHNwb2VsMS5henVyZWNyLmlvIiwidmVyc2lvbiI6IjEuMCIsInJpZCI6ImY2ZWJiY2IzM2M4YjQwYmNhOTIyMTdiMWY3ZWViNDQzIiwiZ3JhbnRfdHlwZSI6InJlZnJlc2hfdG9rZW4iLCJhcHBpZCI6IjA0YjA3Nzk1LThkZGItNDYxYS1iYmVlLTAyZjllMWJmN2I0NiIsInRlbmFudCI6ImI5MWI0YzQ2LWMzYzUtNGE4Mi1iZTFjLTYwMDliMzAwMjQ0NCIsInBlcm1pc3Npb25zIjp7IkFjdGlvbnMiOlsicmVhZCIsIndyaXRlIiwiZGVsZXRlIiwibWV0YWRhdGEvcmVhZCIsIm1ldGFkYXRhL3dyaXRlIiwiZGVsZXRlZC9yZWFkIiwiZGVsZXRlZC9yZXN0b3JlL2FjdGlvbiJdLCJOb3RBY3Rpb25zIjpudWxsfSwicm9sZXMiOltdfQ.IHDddOUND--3clT_v8RVC39FwBxjUQzJ6fcKiDOryzgXKLf_owRaoZd2kRoVNGCzvA9-dctRPZ5clq_AaTA2p4HsRJ9g4w8YZSxr8Uc0jXmFr5p7lmCvrwiJ0uUVRuCQlb0frvT8Ft9hFO3TBdTr-tN7fKFiXve8rlpX0qQ5Lkjd1dmUWmqmMPz8VpECs4yzyOYqL4armxsgMpvr9fPXDf2JJUQCMTu6Kbxu6QSGYNr0oJfGVxQjVn5Fl2n8Oa0xDkwK3BFYHsjpjhhOOvslWWllzz0Oll8KNk_a0MIWlIQr4-90lILn3O39cEBzTRvcYdkw8daEujp7IdVdkZfBeg
                sh 'docker push acrDevopsPoel1.azurecr.io/spring-openjdk:11'
            }
        }

        stage('Deploy with Helm') {
            steps {
                script {
                    sh 'helm install petclinic-latest helm-app/helmpetlcinic'
                }
            }
        }

        stage('Remove Docker Permissions') {
            steps {
                script {
                    sh 'sudo chmod 660 /var/run/docker.sock'
                    sh 'sudo apt update'
                }
            }
        }
    }
}
