resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = merge(
    {
      Name        = var.name,
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )
}


resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr_blocks)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    {
      Name        = "public_Subnet",
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )

}


resource "aws_route_table" "subnet-route-table" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      Name        = "PublicRouteTable",
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      Name        = "InternetGW",
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )
}

resource "aws_route" "subnet-route" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  route_table_id         = aws_route_table.subnet-route-table.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidr_blocks)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.subnet-route-table.id
}

resource "aws_instance" "instance" {
  count                       = var.instance_count
  ami                         = lookup(var.images,var.region)
  instance_type               = "t2.small"
  vpc_security_group_ids      = [ aws_security_group.security-group.id ]
  subnet_id                   = element(aws_subnet.public.*.id, count.index)
  associate_public_ip_address = true
  user_data                   = <<EOF
#!/bin/sh
yum install -y nginx
service nginx start
EOF

tags = merge(
    {
      Name        = "Bastion",
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )

}

resource "aws_security_group" "security-group" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

# configured to output the first instance
output "nginx_domain" {
  value = aws_instance.instance[0].public_dns
}
