resource "aws_security_group" "workshop_security_group" {
   name        = "workshop Security Group"
   description = "Allow traffic to access workshop instrance"
   vpc_id = aws_vpc.workshop.id
    ingress {
      from_port       = 22
      to_port         = 22
      protocol        = "tcp"
      cidr_blocks = ["181.135.14.57/32"]
    }
    ingress {
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      cidr_blocks = ["181.135.14.57/32"]
    }
    ingress {
      from_port       = 443
      to_port         = 443
      protocol        = "tcp"
      cidr_blocks = ["181.135.14.57/32"]
    }
    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  tags = {
    Environment = var.env
    name = "sg-workshop-instance"
  }
}