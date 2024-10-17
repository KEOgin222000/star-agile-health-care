pipeline{
    agent any
      tools {
           maven 'M2_HOME'
      }
    stages{
        stage('git checkout'){
            steps{
                echo 'This Stage is to Clone the repo form github'
                 git branch: 'master' , url: 'https://github.com/KEOgin222000/star-agile-health-care/'
                             }
             }
        
        stage ('Create Package') {
            Steps {
                echo ' This Stage Will Compile , test , package  my application'
                sh 'mvn package'
                      }
          }
        stage ('Generate Test Report') {
            steps { 
                echo 'This stage generate test report using TestNG'
                publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '/var/lib/jenkins/workspace/Health care/target/surefire-reports', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: '', useWrapperFileDirectly: true])
            }
        }
    }
}