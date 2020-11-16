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
        stage('Clean Workspaces -----------') { 
            steps {
              cleanWs()
              sh 'env'
            } //steps
        }    
        stage('Load Terraform code -----------') {     
            steps {
                checkout([$class: 'GitSCM', 
                branches: [[name: '*/main']], 
                doGenerateSubmoduleConfigurations: false, 
                extensions: [[$class: 'CleanCheckout']], 
                submoduleCfg: [], 
                userRemoteConfigs: [
                        [url: 'https://github.com/ezequiellladoce/Despliege_Terrafom-Ansible_con_Jenkins.git', credentialsId: '']
                        ]])
                sh 'pwd' 
                sh 'ls -l'
            } //steps
        }  //stage
        stage('Terraform init----') {
         steps {
            sh 'terraform --version'
            sh 'terraform init'
            } //steps
        }  //stage
                stage('Terraform plan----') {
            steps {
               sh 'terraform plan'
            } //steps
        }  //stage
        stage('Confirmación de accion') {
            steps {
                script {
                    def userInput = input(id: 'confirm', message: params.ACCION + '?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Apply terraform', name: 'confirm'] ])
                }
            }//steps
        }//stage
        stage('Terraform apply or destroy ----------------') {
            steps {
               sh 'echo "comienza"'
            script{  
                if (params.ACCION == "destroy"){
                         sh ' echo "llego" + params.ACCION'   
                         sh 'terraform destroy -auto-approve'
                } else {
                         sh ' echo  "llego" + params.ACCION'                 
                         sh ' terraform apply -auto-approve'  
                }  // if
            }
            } //steps
        }  //stage
   }  // stages
}//pipeline