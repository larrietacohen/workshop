resource "aws_instance" "workshop_instance_a" {
   ami             = var.ami
   instance_type   = var.instance_type
   vpc_security_group_ids = [aws_security_group.workshop_security_group.id]
   key_name        = aws_key_pair.kp.key_name
   subnet_id       = aws_subnet.public-net1.id
   depends_on      = [aws_security_group.workshop_security_group]
   private_ip = "10.10.0.100"
#    iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
   ebs_block_device {
      device_name = "/dev/xvda"
      volume_size = 20
   }
   tags = {
    Env  = var.env
    Name = "Instance A"
   }
}

resource "aws_instance" "workshop_instance_b" {
   ami             = var.ami
   instance_type   = var.instance_type
   vpc_security_group_ids = [aws_security_group.workshop_security_group.id]
   key_name        = aws_key_pair.kp.key_name
   subnet_id       = aws_subnet.private-net1.id
   depends_on      = [aws_security_group.workshop_security_group]
   private_ip = "10.10.32.100"
#   iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
   ebs_block_device {
      device_name = "/dev/xvda"
      volume_size = 20
   }
   tags = {
    Env  = var.env
    Name = "Instance B"
   }
}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = "workshop"       # Create "workshop" to AWS!!
  public_key = tls_private_key.pk.public_key_openssh

  provisioner "local-exec" { # Create "workshop.pem" to your computer!!
    command = "echo '${tls_private_key.pk.private_key_pem}' > ./workshop.pem"
  }
}

resource "aws_eip" "dev_workshop_eip" {
  vpc = true
  tags = {
    Env  = "qa",
    Name = "eip-workshop"
  }
}

resource "aws_eip_association" "dev_eip_assoc" {
  instance_id   = aws_instance.workshop_instance_a.id
  allocation_id = aws_eip.dev_workshop_eip.id
}