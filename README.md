# Despliege Terraform con Jenkins

El objetivo de este repositorio es automátizar desde Jenkins con Plipelines declarativos el despliege de una infraestructura basica de AWS ( EC2-VPC-IG-SG etc.) tomando el codigo de terraform desde Git.

## Pre-requisitos 📋

- TERRAFORM .12
- AWS CLI 1.18.69
- CUENTA FREE TIER AWS 
- Servidor Jenkins

## Comenzando 🚀

1) Instalalamos Terrafom https://learn.hashicorp.com/tutorials/terraform/install-cli
2) Creamos cuenta free tier en AWS  https://aws.amazon.com/
3) Instalamos AWS CLI https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html
4) Creamos usario AWS en la seccion IAM con acceso Programatico y permisos de administrador https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html   
5) Configuramos el AWS CLI https://docs.aws.amazon.com/polly/latest/dg/setup-aws-cli.html
6) Instalamos Servidor Jenkins https://www.jenkins.io/doc/book/installing/linux/

## Despliegue 📦

### Consideraciones iniciales

- Para la realización de este despliegue tenemos ya desarrollado y probado el codigo terraform en git.
- Verificamos que el Jenkins tenga instado el plugin te terraform y este correctamente configurado https://medium.com/appgambit/terraform-with-jenkins-pipeline-439babe4095c
- Configuramos las claves AWS en Jenkins https://www.cyberark.com/resources/threat-research-blog/configuring-and-securing-credentials-in-jenkins

### Creamos el pipeline

- Creamos una Nueva Tarea

![imagen](https://user-images.githubusercontent.com/67485607/99402782-7c5d6d80-28c8-11eb-8305-f64c388394f4.png)

- Vamos a la sección pipeline

![J2](https://user-images.githubusercontent.com/67485607/99403995-e0346600-28c9-11eb-9c8f-cc8cad75b63f.PNG)

- El codigo que usaremmos es el siguinte:

''' 
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
                        [url: 'https://github.com/ezequiellladoce/Despliege_Terrafom_con_Jenkins.git', credentialsId: '']
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

'''











