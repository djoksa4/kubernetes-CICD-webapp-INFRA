
#### INSTANCES ##################################################################################

resource "aws_instance" "controlplane" {
  ami           = "ami-0427090fd1714168b" # AMAZON Linux AMI
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.sn_pub_A.id
  private_ip = "10.0.0.70"
 

  key_name = "A4L"

  vpc_security_group_ids = [aws_security_group.controlplane_sg.id]

  tags = {
    Name = "controlplane"
  }

  # Provisioning script
  # user_data = file("${path.module}/provisioning_scripts/general.sh")

}

resource "aws_instance" "workernode01" {
  ami           = "ami-0427090fd1714168b" # AMAZON Linux AMI
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.sn_pub_A.id
  private_ip = "10.0.0.71"

  key_name = "A4L"

  vpc_security_group_ids = [aws_security_group.workernode_sg.id]

  tags = {
    Name = "workernode01"
  }

  # Provisioning script
  # user_data = file("${path.module}/provisioning_scripts/general.sh")
  
}

# resource "aws_instance" "workernode02" {
#   ami           = "ami-04a81a99f5ec58529" # Ubuntu Linux AMI
#   instance_type = "t2.medium"
#   subnet_id     = aws_subnet.sn_pub_A.id
#   private_ip = "10.0.0.72"

#   key_name = "A4L"

#   vpc_security_group_ids = [aws_security_group.workernode_sg.id]

#   tags = {
#     Name = "workernode02"
#   }

#   # Provisioning script
#   user_data = file("${path.module}/provisioning_scripts/general.sh")

# }





#### SECURITY GROUPS ##################################################################################
resource "aws_security_group" "controlplane_sg" {
  name        = "controlplane_sg"

  vpc_id = aws_vpc.this.id

  # Allow inbound SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound HTTP
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound for Kubernetes API server
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound for etcd server client API
  ingress {
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound for kubelet, kube-scheduler, and kube-controller
  ingress {
    from_port   = 10250
    to_port     = 10259
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound UDP for Weave Net
  ingress {
    from_port   = 6783
    to_port     = 6784
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  } 

  # Allow inbound TCP for Weave Net
  ingress {
    from_port   = 6783
    to_port     = 6783
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 

  # Allow outbound traffic to the internet or other resources
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "workernode_sg" {
  name        = "workernode_sg"

  vpc_id = aws_vpc.this.id

  # Allow inbound SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound traffic for Kubelet API etc
  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound traffic for NodePort services (if used)
  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound UDP for Weave Net
  ingress {
    from_port   = 6783
    to_port     = 6784
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  } 

  # Allow inbound TCP for Weave Net
  ingress {
    from_port   = 6783
    to_port     = 6783
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 

  # Allow outbound traffic to the internet or other resources
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

