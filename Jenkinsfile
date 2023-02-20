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
                    def dockerPath = sh(returnStdout: true, script: 'which docker').trim()
                    if (dockerPath) {
                        echo 'Docker is already installed, skipping installation'
                    } else {
                        sh 'sudo apt-get update'
                        sh 'sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common'
                        sh 'curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -'
                        sh 'sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"'
                        sh 'sudo apt-get update'
                        sh 'sudo apt-get install -y docker-ce docker-ce-cli containerd.io'
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
                    docker stop my-capstone-project-1 || true
                    docker rm my-capstone-project-1 || true
                    docker run -d -p 8081:80 --name my-capstone-project-1 vinod0510/automation-djkt:latest
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
                        sh 'kubectl apply -f deploy.yaml --record=true'
                        sh 'kubectl apply -f service.yaml'
                    } catch (error) {
                        sh 'kubectl create -f deploy.yaml'
                        sh 'kubectl create -f service.yaml'
                    }
                }
            }
        }
    }
}
