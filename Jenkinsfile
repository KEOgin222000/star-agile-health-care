pipeline{
 agent any
    tools {
        maven 'M2_HOME'
    } 
 stages {
    stage('git checkout') {
        steps {
            echo 'This Stage is to Clone the repo form github'
            git branch: 'master' , url: 'https://github.com/KEOgin222000/star-agile-health-care/'
            // Other git checkout steps here
        }
    }
    stage ('Create Package') {
        steps {
            echo ' This Stage Will Compile , test , package  my application'
            sh 'mvn package'
             // Package steps here
          }
      }
    stage ('Generate Test Report') {
        steps { 
            echo 'This stage generate test report using TestNG'
            publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '/var/lib/jenkins/workspace/Health care/target/surefire-reports', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: '', useWrapperFileDirectly: true])
            // Test steps here
            }
        }
    stage ('Create Docker Image ') {
        steps {
            echo ' This Stage Will create docker Image'
            sh 'docker build -t keogin/healthcare:1.0 .'
            // Docker Image steps here
                      }
             }
    stage ('Login to Dockerhub ') {
          steps {
            echo ' This Stage Willlogin to Dockerhub'
            withCredentials([usernamePassword(credentialsId: 'dockerloginnew', passwordVariable: 'dockerpass', usernameVariable: 'dockeruser')]) {
            sh 'docker login -u ${dockeruser} -p${dockerpass}' 
                     }
                }
           }
    stage ('Docker push image ') {
        steps {
            echo ' This Stage Will push my new Imageto the dockerhub'
            sh 'docker push keogin/healthcare:1.0'
             // Docker push imagesteps here
         }
    }
    stage('AWS-Login') {
        steps {
            withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'awsaccess', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
         }
      }
    }
    stage('Terraform Operations for test workspace') {
      steps {
        script {
          sh '''
            terraform workspace select test || terraform workspace new test
            terraform init
            terraform plan
            terraform destroy -auto-approve
          '''
        }
      }
    }
    stage('Terraform destroy & apply for test workspace') {
      steps {
        sh 'terraform apply -auto-approve'
      }
    }
    stage('get kubeconfig') {
      steps {
        sh 'aws eks update-kubeconfig --region us-east-1 --name test-cluster'
        sh 'kubectl get nodes'
      }
    }
    stage('Deploying the application') {
      steps {
        sh 'kubectl apply -f app-deploy.yml'
        sh 'kubectl get svc'
      }
    }
    stage('Terraform Operations for Production workspace') {
      when {
        expression {
          return currentBuild.currentResult == 'SUCCESS'
        }
      }
      steps {
        script {
          sh '''
            terraform workspace select prod || terraform workspace new prod
            terraform init
            terraform plan
            terraform destroy -auto-approve
          '''
        }
      }
    }
    stage('Terraform destroy & apply for production workspace') {
      steps {
        sh 'terraform apply -auto-approve'
      }
    }
    stage('get kubeconfig for production') {
      steps {
        sh 'aws eks update-kubeconfig --region us-east-1 --name prod-cluster'
        sh 'kubectl get nodes'
      }
    }
    stage('Deploying the application to production') {
      steps {
        sh 'kubectl apply -f app-deploy.yml'
        sh 'kubectl get svc'
      }
    }
  }
}
 
    

        
