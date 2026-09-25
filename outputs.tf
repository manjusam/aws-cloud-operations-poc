output "web_server_public_ip" {
  description = "Public IP address of the EC2 web server"
  value       = aws_instance.web.public_ip
}

output "web_server_url" {
  description = "URL of the NGINX web server"
  value       = "http://${aws_instance.web.public_ip}"
}

output "s3_bucket_name" {
  description = "Name of the operations S3 bucket"
  value       = aws_s3_bucket.operations.id
}