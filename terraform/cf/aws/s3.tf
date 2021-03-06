resource "aws_s3_bucket_object" "cf-var-store" {
  bucket                 = "${var.state_bucket_id}"
  acl                    = "private"
  key                    = "cf/cf-variables.yml"
  source                 = "/dev/null"
  server_side_encryption = "aws:kms"
  kms_key_id             = "${var.s3_kms_key_arn}"
}
