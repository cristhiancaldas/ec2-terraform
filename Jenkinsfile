pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "us-east-1"
    }
    stages {
        stage('Setup') {
            steps {
                dir('eks') {
                    deleteDir()
            }
            }
        }
        stage('Checkout SCM'){
            steps{
                script{
                    checkout scmGit(branches: [[name: '*/feature/eks-terraform']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/cristhiancaldas/ec2-terraform.git']])
                }
            }
        }
        stage('Initializing Terraform'){
            steps{
                script{
                    dir('eks'){
                        sh 'terraform init'
                    }
                }
            }
        }
        stage('Formatting Terraform Code'){
            steps{
                script{
                    dir('eks'){
                        sh 'terraform fmt'
                    }
                }
            }
        }
        stage('Validating Terraform'){
            steps{
                script{
                    dir('eks'){
                        sh 'terraform validate'
                    }
                }
            }
        }
        stage('Previewing the Infra using Terraform'){
            steps{
                script{
                    dir('eks'){
                        sh 'terraform plan'
                    }
                    input(message: "Are you sure to proceed?", ok: "Proceed")
                }
            }
        }

        stage('Creating/Destroying an EKS Cluster'){
            steps{
                script{
                    dir('eks') {
                        sh 'terraform apply --auto-approve'
                    }
                }
            }
        }
        
        stage('Deploying Nginx Application') {
            steps{
                script{
                    dir('eks/configurationFiles') {
                        sh 'aws eks update-kubeconfig --name my-eks-cluster'
                        sh 'kubectl apply -f deployment.yaml'
                        sh 'kubectl apply -f service.yaml'
                    }
                }
            }
        }
    }
}