
resource "aws_autoscaling_group" "asg" {
  vpc_zone_identifier = [aws_subnet.private[0].id,aws_subnet.private[1].id]
  desired_capacity    = 2
  max_size            = 2
  min_size            = 2

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  # tags = {
  #   Name  = "Custom-asg"
  #   Owner = var.owner_name
  # }

}