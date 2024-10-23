pipeline {
    agent any
    tools {
        maven 'M2_HOME'
    }

    stages {
        stage('Git Checkout') {
            steps {
                echo 'This Stage is to Clone the repo from GitHub'
                git branch: 'master', url: 'https://github.com/KEOgin222000/star-agile-health-care/'
            }
        }

        stage('Create Package') {
            steps {
                echo 'This Stage Will Compile, Test, and Package the Application'
                sh 'mvn package'
            }
        }

        stage('Generate Test Report') {
            steps {
                echo 'This Stage Will Generate Test Report Using TestNG'
                publishHTML([
                    allowMissing: false, 
                    alwaysLinkToLastBuild: false, 
                    keepAll: false, 
                    reportDir: '/var/lib/jenkins/workspace/Health care/target/surefire-reports', 
                    reportFiles: 'index.html', 
                    reportName: 'HTML Report', 
                    reportTitles: '', 
                    useWrapperFileDirectly: true
                ])
            }
        }

        stage('Create Docker Image') {
            steps {
                echo 'This Stage Will Create a Docker Image'
                sh 'docker build -t keogin/healthcare:1.0 .'
            }
        }

        stage('Login to Docker Hub') {
            steps {
                echo 'This Stage Will Login to Docker Hub'
                withCredentials([usernamePassword(credentialsId: 'dockerloginnew', passwordVariable: 'dockerpass', usernameVariable: 'dockeruser')]) {
                    sh 'docker login -u ${dockeruser} -p${dockerpass}'
                }
            }
        }

        stage('Docker Push Image') {
            steps {
                echo 'This Stage Will Push the Image to Docker Hub'
                sh 'docker push keogin/healthcare:1.0'
            }
        }

        stage('AWS Login') {
            steps {
                echo 'This Stage Will Login to AWS'
                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'awsaccess', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    // AWS login happens here
                }
            }
        }

        stage('Terraform Operations for Test Workspace') {
            steps {
                script {
                    echo 'Terraform Init, Plan, and Destroy for Test Workspace'
                    sh '''
                        terraform workspace select test || terraform workspace new test
                        terraform init
                        terraform plan
                        terraform destroy -auto-approve
                    '''
                }
            }
        }

        stage('Terraform Apply for Test Workspace') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }

        stage('Get Kubeconfig for Test Cluster') {
            steps {
                echo 'Get kubeconfig for Test Cluster and Verify Nodes'
                sh 'aws eks update-kubeconfig --region us-east-1 --name test-cluster'
                sh 'kubectl get nodes'
            }
        }

        stage('Deploying Application to Test Cluster') {
            steps {
                echo 'Deploying Application to Test Cluster'
                sh 'kubectl apply -f app-deploy.yml'
                sh 'kubectl get svc'
            }
        }

        stage('Terraform Operations for Production Workspace') {
            when {
                expression {
                    return currentBuild.currentResult == 'SUCCESS'
                }
            }
            steps {
                script {
                    echo 'Terraform Init, Plan, and Destroy for Production Workspace'
                    sh '''
                        terraform workspace select prod || terraform workspace new prod
                        terraform init
                        terraform plan
                        terraform destroy -auto-approve
                    '''
                }
            }
        }

        stage('Terraform Apply for Production Workspace') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }

        stage('Get Kubeconfig for Production Cluster') {
            steps {
                echo 'Get kubeconfig for Production Cluster and Verify Nodes'
                sh 'aws eks update-kubeconfig --region us-east-1 --name prod-cluster'
                sh 'kubectl get nodes'
            }
        }

        stage('Deploying Application to Production Cluster') {
            steps {
                echo 'Deploying Application to Production Cluster'
                sh 'kubectl apply -f app-deploy.yml'
                sh 'kubectl get svc'
            }
        }
    }
}

 
    

        
