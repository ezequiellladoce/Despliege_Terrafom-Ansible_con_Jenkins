#!/bin/bash
sudo yum -y update 
sudo amazon-linux-extras install docker
sudo yum install docker
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo docker run -d -p 3000:3000 grafana/grafana


