resource "aws_launch_template" "launch_template" {
  name_prefix   = "launch_template"
  image_id      = "ami-0d71ea30463e0ff8d"
  instance_type = "t2.micro"

  tags = {
    Name  = "Custom-launch-template"
    Owner = var.owner_name
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name  = "Custom-EC2"
      Owner = var.owner_name
  }
  }
  user_data = filebase64("./myscript.sh")
}