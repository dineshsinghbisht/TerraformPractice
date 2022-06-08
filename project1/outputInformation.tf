output "EC2-Instance-Id" {
    value = aws_instance.web.id
}

output "EC2-Instance-State" {
    value = aws_instance.web.instance_state
}
