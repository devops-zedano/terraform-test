resource "aws_security_group" "rundeck-test-sg" {
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    // This means, all ip address are allowed to ssh !
    // Do not do it in the production.
    // Put your office or home address in it!
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Rundeck's default exposed port.
  ingress {
    from_port   = 4440
    to_port     = 4440
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "Rundeck Test SG"
    Purpose = "Rundeck testing Vlad Z."
  }
}

resource "aws_instance" "rundeck-test-ec2-instance" {
  ami           = var.ami_id
  instance_type = "t2.micro"

  key_name               = var.key_name
  vpc_security_group_ids = ["${aws_security_group.rundeck-test-sg.id}"]
  subnet_id              = var.subnet_ids[0]

  user_data = <<EOF
#!/bin/bash
yum update -y
rpm -Uvh http://repo.rundeck.org/latest.rpm
yum install -y rundeck java
sed -i s/localhost/$(ifconfig | grep inet | head -n 1 | awk '{print $2}')/g /etc/rundeck/framework.properties
sed -i s/localhost/$(ifconfig | grep inet | head -n 1 | awk '{print $2}')/g /etc/rundeck/rundeck-config.properties

systemctl start rundeckd
EOF

  root_block_device {
    delete_on_termination = true
  }

  tags = {
    Name = "Test Rundeck instance (VLAD Z.)"
  }
}

output "aws_instance_public_ip" {
  value = "${aws_instance.rundeck-test-ec2-instance.private_ip}"
}

output "aws_instance_public_dns" {
  value = "${aws_instance.rundeck-test-ec2-instance.private_dns}"
}
