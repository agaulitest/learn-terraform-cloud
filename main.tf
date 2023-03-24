provider "aws" {
  region = var.region
}

resource "aws_iam_policy" "inline" {
  name        = "tf-inline"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = "vpc-0975ba0b60f84cee8"

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_instance" "project-tc" {
  ami = "ami-07f3ef11ec14a1ea3"
  instance_type = "m5.2xlarge"
  subnet_id = "subnet-04f5b12a5398896d7"
  vpc_security_group_ids = [
    aws_security_group.allow_tls.id
  ]
  root_block_device {
    delete_on_termination = true
    iops = 150
    volume_size = 50
    volume_type = "gp2"
  }
  tags = {
  }

}

