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
    green = {
      subnet = "app-a"
      type   = "t3.medium"
      role   = "app"
    }

    blue = {
      subnet = "app-b"
      type   = "t3.medium"
      role   = "app"
    }

    database = {
      subnet = "db-a"
      type   = "t3.medium"
      role   = "db"
    }
  }


}