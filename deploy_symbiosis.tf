# define AWS provider

provider "aws" {
  region     = var.aws_region
  version    = "~> 2.0"
}

# Create Network

resource "aws_vpc" "symbiosis_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  
  tags = {
    Name = "symbiosis_vpc"
  }
}

resource "aws_route" "access_IGW" {
  route_table_id = aws_vpc.symbiosis_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}


resource "aws_route_table" "nat" {
  vpc_id = aws_vpc.symbiosis_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.db.id
  }
  
  tags = {
    Name = "nat_rt"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.sub_private.id
  route_table_id = aws_route_table.nat.id
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.symbiosis_vpc.id
  
  tags = {
    Name = "symbiosis_igw"
  }
}

resource "aws_eip" "nat" {
  vpc = true
  public_ipv4_pool = "amazon"
  depends_on = [aws_internet_gateway.gw]
  
  tags = {
    Name = "eip_nat"
  }
}

resource "aws_nat_gateway" "db" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.sub_private.id
  depends_on = [aws_internet_gateway.gw]

  tags = {
    Name = "NAT GW"
  }
}

resource "aws_subnet" "sub_public" {
  vpc_id     = aws_vpc.symbiosis_vpc.id
  cidr_block = var.pub_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "sub_public"
  }
}

resource "aws_subnet" "sub_private" {
  vpc_id     = aws_vpc.symbiosis_vpc.id
  cidr_block = var.pri_subnet_cidr

  tags = {
    Name = "sub_private"
  }
}


resource "aws_security_group" "sg_public" {
  name        = "sg_devops"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = aws_vpc.symbiosis_vpc.id

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "sg_public"
  }
}

# create key pair

resource "aws_key_pair" "kp_symbiosis" {
  key_name   = "kp_symbiosis"
  public_key = var.public_sshkey

  tags = {
    Name = "access"
  }
}

resource "aws_instance" "webserver" {
  ami           = var.image
  instance_type = var.type
  key_name = aws_key_pair.kp_symbiosis.key_name
  vpc_security_group_ids = [aws_security_group.sg_public.id]
  subnet_id = aws_subnet.sub_public.id
  associate_public_ip_address = true

  tags = {
    Name = "webserver"
  }
}

resource "aws_instance" "database" {
  ami           = var.image
  instance_type = var.type
  key_name = aws_key_pair.kp_symbiosis.key_name
  vpc_security_group_ids = [aws_security_group.sg_public.id]
  subnet_id = aws_subnet.sub_public.id
  associate_public_ip_address = false

  tags = {
    Name = "database"
  }
}

output "webserver_public_ip" {
  value = aws_instance.webserver.public_ip
}
