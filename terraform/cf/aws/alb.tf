resource "aws_lb" "cf" {
  name                             = "${var.environment}-cf-alb"
  subnets                          = ["${aws_subnet.az1.id}", "${aws_subnet.az2.id}", "${aws_subnet.az3.id}"]
  security_groups                  = ["${aws_security_group.cf_alb.id}"]
  load_balancer_type               = "application"
  internal                         = false
  enable_cross_zone_load_balancing = true

  tags {
    Name        = "${var.environment}-cf-alb"
    Environment = "${var.environment}"
  }
}

resource "aws_lb_listener" "cf" {
  depends_on        = ["aws_acm_certificate_validation.cf"]
  load_balancer_arn = "${aws_lb.cf.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = "${aws_acm_certificate.cf.arn}"

  default_action {
    target_group_arn = "${aws_lb_target_group.cf.arn}"
    type             = "forward"
  }
}

resource "aws_lb_target_group" "cf" {
  name     = "${var.environment}-cf-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 5
  }

  tags {
    Name        = "${var.environment}-cf-target-group"
    Environment = "${var.environment}"
  }
}