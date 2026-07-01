locals {
  common_tags = {
    Project     = "FastAPI"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }

  subnets = {
      public-a = {
      cidr = "10.0.1.0/24"
      az   = "ap-south-1a"
      type = "public"
    }

    public-b = {
      cidr = "10.0.2.0/24"
      az   = "ap-south-1b"
      type = "public"
    }

    app-a = {
      cidr = "10.0.11.0/24"
      az   = "ap-south-1a"
      type = "private-app"
    }

    app-b = {
      cidr = "10.0.12.0/24"
      az   = "ap-south-1b"
      type = "private-app"
    }

    db-a = {
      cidr = "10.0.21.0/24"
      az   = "ap-south-1a"
      type = "private-db"
    }

    db-b = {
      cidr = "10.0.22.0/24"
      az   = "ap-south-1b"
      type = "private-db"
    }

  }

  instances = {

    bastion = {
      ami_name            = "ubuntu"
      instance_type       = "t3.micro"
      subnet              = "public-a"
      security_group      = "bastion"
      associate_public_ip = true
      private_ip          = "10.0.1.10"
    }

    green = {
      ami_name            = "ubuntu"
      instance_type       = "t3.medium"
      subnet              = "app-a"
      security_group      = "app"
      associate_public_ip = false
      private_ip          = "10.0.11.10"
    }

    blue = {
      ami_name            = "ubuntu"
      instance_type       = "t3.medium"
      subnet              = "app-b"
      security_group      = "app"
      associate_public_ip = false
      private_ip          = "10.0.12.10"
    }

    database = {
      ami_name            = "ubuntu"
      instance_type       = "t3.medium"
      subnet              = "db-a"
      security_group      = "db"
      associate_public_ip = false
      private_ip          = "10.0.21.10"
    }

  }

  security_groups = {

    alb = {
      description = "Application Load Balancer Security Group"
    }

    app = {
      description = "Application Security Group"
    }

    db = {
      description = "Database Security Group"
    }

    bastion = {
      description = "Bastion Host Security Group"
    }

  }

  target_groups = {
    blue = {
      port = 80
    }

    green = {
      port = 80
    }

    production = {
      port = 80
    }
  }


}