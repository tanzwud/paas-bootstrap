resource "aws_subnet" "az1" {
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.az1}"

  tags {
    Name        = "${var.environment}-az1-subnet"
    Environment = "${var.environment}"
    Visibility  = "public"
  }
}

resource "aws_subnet" "az2" {
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.az2}"

  tags {
    Name        = "${var.environment}-az2-subnet"
    Environment = "${var.environment}"
    Visibility  = "public"
  }
}

resource "aws_subnet" "az3" {
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "10.0.12.0/24"
  availability_zone = "${var.az3}"

  tags {
    Name        = "${var.environment}-az3-subnet"
    Environment = "${var.environment}"
    Visibility  = "public"
  }
}
