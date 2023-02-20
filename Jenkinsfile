
pipeline {
    agent any

    stages {
         stage('Clone_Repo'){
            steps {
                sh 'git init'
                sh 'git clone https://github.com/Vinodvarma1999/Automation_with_Docker_K8s_Jenkins.git'
            }
        }
        
         stage('Build_Image'){
            steps {
                sh 'docker build -t vinod0510/automation-djkt:latest .'
            }
        }
        
        stage('Run_Container') {
             steps {
                sh '''
                  #!/bin/bash
                    docker rm -f $(sudo docker ps -a -q)
                    docker run -d -p 8081:80 --name my-capstone-project-1 vinod0510/automation-djkt:latest
               '''
               }
           }     

        stage('Push_Image'){
            steps {
                withCredentials([string(credentialsId: 'vinod0510', variable: 'vinod0510')]) {
                 sh '''
                   #!bin/bash  
                     docker login -u vinod0510 -p ${vinod0510}'
                     docker push  vinod0510/automation-djkt:latest'
                     docker rm -f $(sudo docker ps -a -q)'
                     docker rmi vinod0510/automation-djkt:latest    
                ''' 
                }
                
            }
       }
       stage('Deploy_On_K8s_Server') {
           agent {
               label 'k_master'
            }
            steps {
                script{
                       try{
                           sh "kubectl apply  -f deploy.yaml --record=true"
                           sh "kubectl apply -f service.yaml"
                       }
                       catch(error){
                           sh "kubectl create -f deploy.yaml"
                           sh "kubectl create -f service.yaml"
                       }
                       }
                   }
                   
               
           }
       }
       
}
  
