###############################################################################
# EC2 - Elastic Compute Cloud
###############################################################################

# https://www.terraform.io/docs/providers/aws/r/instance.html

resource "aws_instance" "concourse" {

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  key_name               = aws_key_pair.key_pair.key_name
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.concourse-sg.id]

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = join("", tls_private_key.private_key.*.private_key_pem)
  }

  provisioner "file" {
    content = <<-EOF
version: '3'

services:
  concourse-db:
    image: postgres
    environment:
      POSTGRES_DB: concourse
      POSTGRES_PASSWORD: concourse_pass
      POSTGRES_USER: concourse_user
      PGDATA: /database

  concourse:
    image: concourse/concourse
    command: quickstart
    privileged: true
    depends_on: [concourse-db]
    ports: ["8080:8080"]
    environment:
      CONCOURSE_POSTGRES_HOST: concourse-db
      CONCOURSE_POSTGRES_USER: concourse_user
      CONCOURSE_POSTGRES_PASSWORD: concourse_pass
      CONCOURSE_POSTGRES_DATABASE: concourse
      CONCOURSE_EXTERNAL_URL: http://${self.public_dns}:8080
      CONCOURSE_ADD_LOCAL_USER: test:test
      CONCOURSE_MAIN_TEAM_LOCAL_USER: test
      CONCOURSE_WORKER_BAGGAGECLAIM_DRIVER: overlay
EOF

    destination = "~/docker-compose.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo rm /boot/grub/menu.lst ",
      "sudo update-grub-legacy-ec2 -y",
      "sudo apt upgrade -y",
      "sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y",
      "sudo curl -fsSL https://get.docker.com -o get-docker.sh",
      "sudo chmod +x get-docker.sh",
      "./get-docker.sh",
      "sudo usermod -aG docker ubuntu",
      "sudo curl -fsSL https://github.com/docker/compose/releases/download/1.25.4/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "sudo docker-compose up -d"
    ]
  }

  tags = {
    Name        = "Concourse"
    Terraform   = "true"
    Environment = "Development"
    Operation   = "Concourse"
  }

}