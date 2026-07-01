resource "aws_instance" "servers" {

  for_each = local.instances

  ami                    = "ami-01a00762f46d584a1"
  instance_type          = each.value.instance_type
  key_name               = "var.key_name"

  subnet_id = aws_subnet.subnets[each.value.subnet].id

  private_ip = each.value.private_ip

  associate_public_ip_address = each.value.associate_public_ip

  vpc_security_group_ids = [
    aws_security_group.sg[each.value.security_group].id
  ]

  root_block_device {

    volume_size = each.key == "database" ? 20 : 15

    volume_type = "gp3"

    delete_on_termination = true

    encrypted = true

  }

  tags = {

    Name = each.key

    Environment = "Production"

    ManagedBy = "Terraform"

    Role = each.key

  }

}