provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "web" {
  ami                         = "ami-03657b56516ab7912"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subnet_public.id
  vpc_security_group_ids      = [aws_security_group.sg_22_80.id]
  associate_public_ip_address = true
  key_name      = "kans3"
  user_data = " ${file("Bash_install_Grafana.sh")} "
}

output "public_ip" {
  value = aws_instance.web.public_ip
}
