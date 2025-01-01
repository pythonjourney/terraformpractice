data "aws_regions" "current" {
  
}

# data "aws_availabilty_zones" "zones" {


# }



data "aws_ami" "ubuntu" {
  
  most_recent      = true
  
  owners           = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_instance" "webserver" {

    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    key_name = "tfdec30"
    vpc_security_group_ids = [ aws_security_group.ssh_sg.id ]

    connection {
      type        = "ssh"
      user        = "ubuntu"             # Default user for Ubuntu AMIs
      private_key = file("C:/Users/Hi/Downloads/tfdec30.pem") # Path to your private key
      host        = self.public_ip
      
    }

    provisioner "remote-exec" {
      
      inline = [ 

        "sudo apt update",
        "sudo apt install nginx -y"
      ]

    }

    tags = {

        Name = "${var.environment}-server"
        TF_Author = "Nagendra"
    }

}

output "current_region" {
  
  value = data.aws_regions.current.id
}

resource "aws_security_group" "ssh_sg" {
  
ingress {

from_port = "22"
to_port = "22"
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]

}

ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

egress {

from_port = "0"
to_port = "0"
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}

}

