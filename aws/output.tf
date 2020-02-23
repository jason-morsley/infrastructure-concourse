output "key_fingerprint" {

  value = aws_key_pair.key_pair.fingerprint

}

output "ami_id" {

  value = data.aws_ami.ubuntu.id

}

output "aws_instance_public_dns" {

  value = aws_instance.concourse.public_dns

}

output "aws_instance_public_ip" {

  value = aws_instance.concourse.public_ip

}