output "strapi_public_ip" {
  description = "Public IP of Strapi EC2"
  value       = aws_instance.strapi_ec2.public_ip
}
