pipeline {
    agent any 
    stages{
        stage("Clone Code"){
            steps {
                echo "Cloning the code"
                git url:"https://github.com/jyotidevop/websitedeployment.git", branch: "main"
            }
        }
        stage("sending docker file and manifest file to ansible server"){
            steps {
              sshagent(['ansible_demo']) {
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.19.110'
                sh 'scp /var/lib/jenkins/workspace/website/* ubuntu@172.31.19.110:/home/ubuntu/'
            }
           }
        }
         stage("docker build image"){
            steps {
              sshagent(['ansible_demo']) {
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.19.110 cd /home/ubuntu/'
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.19.110 docker image build -t $JOB_NAME:v1.$BUILD_ID .'
            }
           }
         }
        stage("docker image tagging"){
            steps {
              sshagent(['ansible_demo']) {
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.19.110 cd /home/ubuntu/'
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.19.110 docker image tag $JOB_NAME:v1.$BUILD_ID jyotichaudhary90/$JOB_NAME:v1.$BUILD_ID'
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.19.110 docker image tag $JOB_NAME:v1.$BUILD_ID jyotichaudhary90/$JOB_NAME:latest'
                
            }
          }
        }
       stage("push docker image to docker hub"){
            steps {
              sshagent(['ansible_demo']) {
                withCredentials([string(credentialsId: 'dockerhub_passwd', variable: 'dockerhub_passwd')]) {
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.19.110 docker login -u jyotichaudhary90 -p $(dockerhub_passwd)'
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.19.110 docker image push jyotichaudhary90/$JOB_NAME:v1.$BUILD_ID'
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.19.110 docker image push jyotichaudhary90/$JOB_NAME:latest'
                
            }
          }
        }
      }
    }
}
