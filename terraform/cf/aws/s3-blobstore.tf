resource "aws_kms_key" "cf-blobstore-key" {
  description             = "This key is used to encrypt CF objects in blobstore"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags {
    Name        = "${var.environment}-cf-blobstore-key"
    Environment = "${var.environment}"
  }
}

resource "aws_s3_bucket" "cf-buildpacks" {
  bucket = "${var.environment}-cf-buildpacks"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.cf-blobstore-key.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags {
    Name        = "${var.environment}-cf-buildpacks"
    Environment = "${var.environment}"
  }
}

resource "aws_s3_bucket" "cf-droplets" {
  bucket = "${var.environment}-cf-droplets"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.cf-blobstore-key.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags {
    Name        = "${var.environment}-cf-droplets"
    Environment = "${var.environment}"
  }
}

resource "aws_s3_bucket" "cf-packages" {
  bucket = "${var.environment}-cf-packages"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.cf-blobstore-key.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags {
    Name        = "${var.environment}-cf-packages"
    Environment = "${var.environment}"
  }
}

resource "aws_s3_bucket" "cf-resource-pool" {
  bucket = "${var.environment}-cf-resource-pool"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.cf-blobstore-key.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags {
    Name        = "${var.environment}-cf-resource-pool"
    Environment = "${var.environment}"
  }
}