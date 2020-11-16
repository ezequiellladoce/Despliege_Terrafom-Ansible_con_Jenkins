pipeline {
    agent any 
    environment {
       AWS_DEFAULT_REGION = 'eu-west-1' 
    }
    options {
      disableConcurrentBuilds()
      parallelsAlwaysFailFast()
      timestamps()
      withCredentials([[
            $class: 'AmazonWebServicesCredentialsBinding', 
            credentialsId: 'awskey', 
            accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
            secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
            ]]) 
    }
    parameters { 
          choice(name: 'ENTORNOS', choices: ['dev', 'pre', 'pro'], description: 'Seleccione el entorno a utilizar')
          choice(name: 'ACCION', choices: ['', 'plan-apply', 'destroy'], description: 'Seleccione el entorno a utilizar')
    }
    stages{ 
        stage('Prueba Aws') {
            steps { 
            sh 'aws --version' 
            sh 'aws s3 ls' 
           // sh 'aws ec2 describe-instances'
           } 
        } 
        stage('clean workspaces -----------') { 
            steps {
              cleanWs()
              sh 'env'
            } //steps
        }    
        stage('load terraform code -----------') {     
            steps {
                checkout([$class: 'GitSCM', 
                branches: [[name: '*/main']], 
                doGenerateSubmoduleConfigurations: false, 
                extensions: [[$class: 'CleanCheckout']], 
                submoduleCfg: [], 
                userRemoteConfigs: [
                        [url: 'https://github.com/ezequiellladoce/DESPLIEGE-DE-CONTAINER-DOCKER-NGINX-EN-INSTANCIA-AWS-CON-TERRAFORM-.git', credentialsId: '']
                        ]])
                sh 'pwd' 
                sh 'ls -l'
            } //steps
        }  //stage
        stage('Terraform init----') {
         steps {
            sh 'terraform --version'
            terraform init -var-file="../variables/dev.tfvars" 
            } //steps
        }  //stage
   }  // stages
}//pipeline