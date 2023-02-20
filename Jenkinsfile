
pipeline {
    agent any

    stages {
         stage('Clone_Repo'){
            steps {
                sh 'git clone https://github.com/Vinodvarma1999/Automation_with_Docker_K8s_Jenkins.git'
            }
        }
        
         stage('Build_Image'){
            steps {
                sh 'sudo docker build -t vinod0510/automation-djkt:latest .'
            }
        }
        
        stage('Run_Container') {
             steps {
                sh '''
                  #!/bin/bash
                    sudo docker rm -f $(sudo docker ps -a -q)
                    sudo docker run -d -p 8081:80 --name my-capstone-project-1 vinod0510/automation-djkt:latest
               '''
               }
           }     

        stage('Push_Image'){
            steps {
                withCredentials([string(credentialsId: 'vinod0510', variable: 'vinod0510')]) {
                 sh '''
                   #!bin/bash  
                     sudo docker login -u vinod0510 -p ${vinod0510}'
                     sudo docker push  vinod0510/automation-djkt:latest'
                     sudo docker rm -f $(sudo docker ps -a -q)'
                     sudo docker rmi vinod0510/automation-djkt:latest    
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
                           sh "sudo kubectl apply  -f deploy.yaml --record=true"
                           sh "sudo kubectl apply -f service.yaml"
                       }
                       catch(error){
                           sh "sudo kubectl create -f deploy.yaml"
                           sh "sudo kubectl create -f service.yaml"
                       }
                       }
                   }
                   
               
           }
       }
       
}
  
