# Fetch AZs in the current region
data "aws_availability_zones" "available" {
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name  = "Custom-VPC"
    Owner = var.owner_name
  }
}

# Create var.az_count private subnets, each in a different AZ
resource "aws_subnet" "private" {
  count             = var.az_count
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.main.id

  tags = {
    Name  = "Private Subnet-${count.index + 1}"
    Owner = var.owner_name
  }
}

# Create var.az_count public subnets, each in a different AZ
resource "aws_subnet" "public" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, var.az_count + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
  tags = {
    Name  = "Public Subnet-${count.index + 1}"
    Owner = var.owner_name
  }
}

# Internet Gateway for internet Communication
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name  = var.owner_name
    Owner = var.owner_name
  }
}


# Create a NAT gateway with an Elastic IP for private subnets
resource "aws_eip" "gw" {
  vpc        = true
  depends_on = [aws_internet_gateway.gw]

  tags = {
    Name  = var.owner_name
    Owner = var.owner_name
  }
}

resource "aws_nat_gateway" "gw" {
  subnet_id     = element(aws_subnet.public[*].id, 0)
  allocation_id = aws_eip.gw.id

  tags = {
    Name  = var.owner_name
    Owner = var.owner_name
  }
}

# Create a new route table for the private subnets, make it route non-local traffic through the NAT gateway to the internet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name  = "For Private Subnets"
    Owner = var.owner_name
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw.id
  }
}

# Explicitly associate the newly created route table to the private subnets
resource "aws_route_table_association" "private" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}

# Create a new route table for the public subnets, make it route non-local traffic through the Internet gateway to the internet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name  = "For Public Subnets"
    Owner = var.owner_name
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

# Explicitly associate the newly created route table to the public subnets
resource "aws_route_table_association" "public" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}
