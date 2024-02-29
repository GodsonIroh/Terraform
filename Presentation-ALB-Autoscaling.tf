# Configure ALB for presentation tier
resource "aws_lb" "Skytroopers-presentation-alb" {
  name               = "Skytroopers-presentation-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.presentation-alb-sg1.id]
  subnets            = [aws_subnet.Skytroopers-pub-sub1.id,aws_subnet.Skytroopers-pub-sub2.id]

  enable_deletion_protection = false


  tags = {
    Environment = "presentation"
  }
}

# Create ALB Listener
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.Skytroopers-presentation-alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.presentation-alb-tg.arn
  }
}

# Create target group for ALB
resource "aws_lb_target_group" "presentation-alb-tg" {
  name        = "presentation-alb-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.Skytroopers-vpc.id
}

resource "aws_lb_target_group_attachment" "front_end" {
  target_group_arn = "${aws_lb_target_group.presentation-alb-tg.arn}"
  target_id        = "${aws_instance.Skytroopers-presentation-instance.id}"
  port             = 80
}

# Create security group for presentation ALB
resource "aws_security_group" "presentation-alb-sg1" {
  name        = "presentation-alb-sg1"
  description = "presentation-alb-sg1"
  vpc_id      = aws_vpc.Skytroopers-vpc.id
ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
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
    Name = "presentation-alb-sg1"
    Project = "Skytroopers" 
  } 
}

resource "aws_launch_template" "presentation-lt" {
  name          = "presentation-lt"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = "Skytroopers-kp"
  vpc_security_group_ids = [aws_security_group.Skytroopers-sg1.id]

  tags = {
    Name = "presentation-lt"
  }
}

resource "aws_autoscaling_group" "presentation-asg" {
  name                      = "presentation-asg"
  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  vpc_zone_identifier       = [aws_subnet.Skytroopers-pub-sub1.id,aws_subnet.Skytroopers-pub-sub2.id]
  target_group_arns         = ["${aws_lb_target_group.presentation-alb-tg.arn}"]

  launch_template {
    id      = aws_launch_template.presentation-lt.id
    version = "$Latest"
  } 
}
