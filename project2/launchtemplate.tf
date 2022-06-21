data "aws_ami" "amazonl_latest_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
resource "aws_launch_template" "launch_template" {
  name_prefix   = "launch_template"
  image_id      = data.aws_ami.amazonl_latest_ami.id
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