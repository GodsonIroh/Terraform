# Configure ALB for presentation tier
resource "aws_lb" "Skytroopers-application-alb" {
  name               = "Skytroopers-application-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.application-alb-sg.id]
  subnets            = [aws_subnet.Skytroopers-priv-sub1.id,aws_subnet.Skytroopers-priv-sub2.id]

  enable_deletion_protection = false


  tags = {
    Environment = "application"
  }
}

# Create ALB Listener
resource "aws_lb_listener" "back_end" {
  load_balancer_arn = aws_lb.Skytroopers-application-alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.application-alb-tg.arn}"
  }
}

# Create target group for ALB
resource "aws_lb_target_group" "application-alb-tg" {
  name        = "application-alb-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.Skytroopers-vpc.id

}

resource "aws_lb_target_group_attachment" "back_end" {
  target_group_arn = "${aws_lb_target_group.application-alb-tg.arn}"
  target_id        = "${aws_instance.Skytroopers-application-instance.id}"
  port             = 80
}

# Create security group for application ALB
resource "aws_security_group" "application-alb-sg" {
  name        = "application-alb-sg"
  description = "application-alb-sg"
  vpc_id      = aws_vpc.Skytroopers-vpc.id
ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
  }
egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
 
 tags = {
    Name = "application-alb-sg"
    Project = "Skytroopers" 
  } 
}

resource "aws_launch_template" "application-lt" {
  name_prefix   = "application-lt"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = "Skytroopers-kp"
  vpc_security_group_ids = [aws_security_group.Skytroopers-sg2.id]

  tags = {
    Name = "application-lt"
  }
}

resource "aws_autoscaling_group" "application-asg" {
  name                      = "application-asg"
  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  vpc_zone_identifier       = [aws_subnet.Skytroopers-priv-sub1.id,aws_subnet.Skytroopers-priv-sub2.id]

  launch_template {
    id      = aws_launch_template.presentation-lt.id
    version = "$Latest"
  }
}