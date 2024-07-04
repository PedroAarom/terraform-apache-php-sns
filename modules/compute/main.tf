provider "aws" {
    region = var.aws_region
}

resource "aws_instance" "web" {
  ami           = var.ami  # AMI de Amazon Linux 2
  instance_type = var.instance_type
  key_name      = var.key_name  # Cambia esto al nombre de tu par de claves SSH
 
  tags = {
    Name = "WebServer"
  }
 
  # Define el Security Group para permitir tráfico HTTP y SSH
  vpc_security_group_ids = [aws_security_group.web_sg.id]
 
  provisioner "file" {
    source      = "./modules/compute/${var.provisioner_file_source}"
    destination = "/tmp/install_apache.sh"
  }
  provisioner "file" {
    source      = "./modules/compute/${var.provisioner_index}"
    destination = "/tmp/index.html"
  }
  provisioner "file" {
    source      = "./modules/compute/${var.provisioner_info}"
    destination = "/tmp/info.php"
  }
  provisioner "file" {
    source      = "./modules/compute/${var.provisioner_submit}"
    destination = "/tmp/submit.php"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_apache.sh",
      "sudo /tmp/install_apache.sh",
      "sudo mv /tmp/index.html /var/www/html/index.html",
      "sudo mv /tmp/info.php /var/www/html/info.php",
      "sudo mv /tmp/submit.php /var/www/html/submit.php",
      "sudo systemctl restart httpd",
      "sudo systemctl restart php-fpm"
    ]
  }
  provisioner "remote-exec" {
    inline = [
      "sudo sed -i 's|arn:aws:sns:us-east-1:XXXXXXX:test|${aws_sns_topic.example.arn}|' /var/www/html/submit.php"
    ]
  }
  
  provisioner "remote-exec" {
    inline = [
      "sudo sed -i '/AddType application\\/x-compress \\.Z/i AddType application\\/x-httpd-php \\.php' /etc/httpd/conf/httpd.conf"
    ]
  }
  connection {
    type        = var.connection_type
    user        = var.connection_user
    private_key = file("./modules/compute/${var.connection_private_key}")  # Ruta a tu clave privada
    host        = self.public_ip
  }
}

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow HTTP and SSH traffic"
 
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_sns_topic" "example" {
  name = "example-topic"
}

resource "aws_sns_topic_subscription" "example_subscription" {
  topic_arn = aws_sns_topic.example.arn
  protocol  = "email"
  endpoint  = var.sns_email_endpoint
}
