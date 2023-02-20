
pipeline {
    agent any

    stages {
        stage('Build_Image'){
            steps {
                sh 'sudo docker build -t vinod0510/my-capstone-project-01 .'
            }
        }
        
        stage('Run_Container') {
             steps {
                sh '''
                  #!/bin/bash
                    sudo docker rm -f $(sudo docker ps -a -q)
                    sudo docker run -d -p 8081:80 --name my-capstone-project-1 vinod0510/my-capstone-project-01:latest
               '''
               }
           }     

        stage('Push_Image'){
            steps {
                withCredentials([string(credentialsId: 'vinod0510', variable: 'vinod0510')]) {
                 sh '''
                   #!bin/bash  
                     sudo docker login -u vinod0510 -p ${vinod0510}'
                     sudo docker push  vinod0510/my-capstone-project-01'
                     sudo docker rm -f $(sudo docker ps -a -q)'
                     sudo docker rmi vinod0510/my-capstone-project-01    
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
  
