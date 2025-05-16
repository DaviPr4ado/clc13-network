resource "aws_vpc" "minha_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "tf-vpc-davi-teste"
  }
}

##cria subnet privada 1a
resource "aws_subnet" "private_subnet_1a" {
  vpc_id     = aws_vpc.minha_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "priv-subnet-1a"
    
  }
}

##cria tabela de rota privada 1a
resource "aws_route_table" "priv_rt_1a" {
  vpc_id = aws_vpc.minha_vpc.id

route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw_1a.id
  }

  tags = {
    Name = "priv-rt-1a"
  }
}

##associa a tabela de rota priv-rt com a subnet privada priv-subnet-1a
resource "aws_route_table_association" "priv_1a_associate" {
  subnet_id      = aws_subnet.private_subnet_1a.id
  route_table_id = aws_route_table.priv_rt_1a.id
}

##cria subnet publica na us east 1a
resource "aws_subnet" "public_subnet_1a" {
  vpc_id     = aws_vpc.minha_vpc.id
  cidr_block = "10.0.100.0/24"
  availability_zone = "us-east-1a"
  
  tags = {
    Name = "pub-subnet-1a"
    
  }

}
##cria tabela de rota publica 1a
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.minha_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "pub_rt"
  }
}

##associa a tabela de rota pub-rt com a subnet publica 
resource "aws_route_table_association" "pub_1a_associate" {
  subnet_id      = aws_subnet.public_subnet_1a.id
  route_table_id = aws_route_table.public_rt.id
}

##cria internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.minha_vpc.id

  tags = {
    Name = "ig-tf-vpc-automation"
  }
}

##cria um ip public para o nat gateway
resource "aws_eip" "nat_gw_ip" {
  domain           = "vpc"
}

##cria um nat gateway 
resource "aws_nat_gateway" "nat_gw_1a" {
  allocation_id = aws_eip.nat_gw_ip.id
  subnet_id     = aws_subnet.public_subnet_1a.id

  tags = {
    Name = "nat-gw-1a"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}


########################################################

##cria subnet 1b privada
resource "aws_subnet" "private_subnet_1b" {
  vpc_id     = aws_vpc.minha_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "priv-subnet-1b"
    
  }
}

##cria tabela de rota privada 1b
resource "aws_route_table" "priv_rt_1b" {
  vpc_id = aws_vpc.minha_vpc.id

route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw_1b.id
  }

  tags = {
    Name = "priv-rt-1b"
  }
}

##associa a tabela de rota priv-rt com a subnet privada priv-subnet-1b
resource "aws_route_table_association" "priv_1b_associate" {
  subnet_id      = aws_subnet.private_subnet_1b.id
  route_table_id = aws_route_table.priv_rt_1b.id
}

##cria subnet publica na us east 1b
resource "aws_subnet" "public_subnet_1b" {
  vpc_id     = aws_vpc.minha_vpc.id
  cidr_block = "10.0.200.0/24"
  availability_zone = "us-east-1b"
  
  tags = {
    Name = "pub-subnet-1b"
    
  }

}

##associa a tabela de rota pub-rt com a subnet publica 
resource "aws_route_table_association" "pub_1b_associate" {
  subnet_id      = aws_subnet.public_subnet_1b.id
  route_table_id = aws_route_table.public_rt.id
}


##cria um ip public para o nat gateway
resource "aws_eip" "nat_gw_ipb" {
  domain           = "vpc"
}

##cria um nat gateway 
resource "aws_nat_gateway" "nat_gw_1b" {
  allocation_id = aws_eip.nat_gw_ipb.id
  subnet_id     = aws_subnet.public_subnet_1b.id

  tags = {
    Name = "nat-gw-1b"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}





