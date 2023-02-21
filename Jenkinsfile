pipeline {
    agent any

    stages {
        stage('Clone Repo') {
            steps {
                sh 'rm -rf Automation_with_Docker_K8s_Jenkins'
                sh 'git clone https://github.com/Vinodvarma1999/Automation_with_Docker_K8s_Jenkins.git'
            }
        }
         
        stage('Install_Docker') {
            steps {
                script {
                    def dockerPath = sh(script: 'which docker', returnStatus: true)
                    if (dockerPath != 0) {
                        sh 'apt update'
                        sh 'apt-get install docker.io -y -q'
                    } else {
                        echo 'Docker is already installed'
                  }
               }
            }
         }        

        stage('Build Image') {
            steps {
                sh 'docker build -t vinod0510/automation-djkt:latest .'
            }
        }

        stage('Run Container') {
            steps {
                sh '''
                    #!/bin/bash
                    docker stop my_project-1 || true
                    docker rm my_project-1 || true
                    docker run -d -p 8081:80 --name my_project-1 vinod0510/automation-djkt:latest
                '''
            }
        }

        stage('Push Image') {
            steps {
                withCredentials([string(credentialsId: 'vinod0510', variable: 'vinod0510')]) {
                    sh '''
                        #!/bin/bash
                        docker login -u vinod0510 -p ${vinod0510}
                        docker push vinod0510/automation-djkt:latest
                    '''
                }
            }
        }

        stage('Deploy to K8s Server') {
            agent {
                label 'k_master'
            }
            steps {
                script {
                    try {
                        sh 'kubectl apply -f deployment.yaml --record=true'
                        sh 'kubectl apply -f services.yaml'
                    } catch (error) {
                        sh 'kubectl create -f deployment.yaml'
                        sh 'kubectl create -f services.yaml'
                    }
                }
            }
        }
    }
}
