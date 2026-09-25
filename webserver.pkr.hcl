packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

source "amazon-ebs" "webserver" {
  region        = "ap-southeast-2"
  instance_type = "t3.micro"
  ssh_username  = "ec2-user"

  source_ami_filter {
    filters = {
      name                = "al2023-ami-2023.*-x86_64"
      virtualization-type = "hvm"
      root-device-type    = "ebs"
    }

    owners      = ["amazon"]
    most_recent = true
  }

  ami_name = "cloud-ops-nginx-{{timestamp}}"
}

build {
  sources = [
    "source.amazon-ebs.webserver"
  ]

  provisioner "shell" {
    inline = [
      "sudo dnf install -y nginx",
      "sudo systemctl enable nginx",
      "echo '<h1>Cloud Operations POC - Packer AMI</h1>' | sudo tee /usr/share/nginx/html/index.html"
    ]
  }
}