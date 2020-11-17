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

- Para crear el piplenine vamos a Nueva Tarea / 





