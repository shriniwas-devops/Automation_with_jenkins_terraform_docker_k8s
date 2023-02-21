# Using environment variable: You can also store your AWS credentials as environment variables. To do this, you can add the following lines to your ~/.bashrc or ~/.bash_profile file:

# export AWS_ACCESS_KEY_ID="your_access_key_id"
# export AWS_SECRET_ACCESS_KEY="your_secret_access_key"

# Make sure to restart your terminal session or run source ~/.bashrc or source ~/.bash_profile for the changes to take effect.

# You can verify this by opening a terminal window and running the echo command to print the value of the exported variables, like this:

# echo $AWS_ACCESS_KEY_ID
# echo $AWS_SECRET_ACCESS_KEY


resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "example-vpc"
  }
}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "example-internet-gateway"
  }
}

resource "aws_route_table" "public" {
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example.id
  }

  vpc_id = aws_vpc.example.id

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_security_group" "example" {
  name        = "example-security-group"
  description = "Allow HTTP and SSH traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.example.id

  tags = {
    Name = "example-security-group"
  }
}

resource "aws_subnet" "example" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "example-subnet"
  }
}

resource "aws_route_table_association" "example" {
  subnet_id = aws_subnet.example.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "example" {
  count    = 2  # Create as per Instance
  instance = aws_instance.example[count.index].id
}

resource "aws_instance" "example" {
  ami           = "ami-0557a15b87f6559cf"
  instance_type = "t2.micro"
  count = var.instance_count
  subnet_id     = aws_subnet.example.id

  vpc_security_group_ids = [
    aws_security_group.example.id
  ]

  tags = {
    Name = "example-instance-${count.index + 1}"
  }
}
