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
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.80.242'
                sh 'scp /var/lib/jenkins/workspace/agent/* ubuntu@172.31.80.242:/home/ubuntu/'
            }
           }
        }
       stage("install docker on ansible server"){
            steps {
              sshagent(['ansible_demo']) {
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.80.242 cd /home/ubuntu/'
                 sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.80.242 ansible-playbook ansible.yaml'
            }
          }
        }
         stage("docker build image"){
            steps {
              sshagent(['ansible_demo']) {
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.83.233 cd /home/ubuntu/'
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.83.233 docker image build -t $JOB_NAME:v1.$BUILD_ID .'
            }
           }
         }
        stage("docker image tagging"){
            steps {
              sshagent(['ansible_demo']) {
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.80.233 cd /home/ubuntu/'
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.83.233 docker image tag $JOB_NAME:v1.$BUILD_ID jyotidevop/$JOB_NAME:v1.$BUILD_ID'
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.83.233 docker image tag $JOB_NAME:v1.$BUILD_ID jyotidevop/$JOB_NAME:latest'
                
            }
          }
        }
       stage("push docker image to docker hub"){
            steps {
              sshagent(['ansible_demo']) {
                withCredentials([string(credentialsId: 'dockerhub_passwd', variable: 'dockerhub_passwd')]) {
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.80.233 docker login -u jyotichaudhary90 -p $(dockerhub_passwd)'
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.83.233 docker image push jyotidevop/$JOB_NAME:v1.$BUILD_ID'
                sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.83.233 docker image push jyotidevop/$JOB_NAME:latest'
                
            }
          }
        }
      }
    }
}
