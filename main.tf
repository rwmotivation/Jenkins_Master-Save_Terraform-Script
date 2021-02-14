
provider "aws" {
  region = "eu-west-2"
}

resource "aws_security_group" "SGver2" {
  name        = "SGver2"
  vpc_id      = "vpc-fad09592"
  description = "Security_group-For-Jenkins-Master-Slave-Configs"
  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 9091
    to_port     = 9091
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SGver2"
  }

}
resource "aws_key_pair" "default" {
  key_name   = "##"
  public_key = %%%%%###


resource "aws_instance" "jenkins_master" {
  ami                         = "ami-0089b31e09ac3fffc" # Amaxon Linux 2 AMI from eu-west-2 region
  count                       = 1
  instance_type               = "t2.micro"
  key_name                    = "n1"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.SGver2.id] # ensure this Security Group has port 9091 opened
  user_data                   = templatefile("${path.cwd}/master-bootstrap.tmpl", {})

  tags = {
    Name          = "Jenkins-Master"
    ProvisionedBy = "Terraform"
  }
}


resource "aws_instance" "jenkins_build_agent" {
  ami                         = "ami-0089b31e09ac3fffc" # Amaxon Linux 2 AMI from eu-west-2 region
  count                       = 2
  instance_type               = "t2.micro"
  key_name                    = "n1"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.SGver2.id] # ensure this Security Group has port 9091 opened
  user_data                   = templatefile("${path.cwd}/build-agent-bootstrap.tmpl", {})

  tags = {
    Name          = "Jenkins-Build-Agent-${count.index + 1}"
    ProvisionedBy = "Terraform"
  }
}
