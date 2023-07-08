resource "aws_instance" "nop" {
  ami             = "ami-0c65adc9a5c1b5d7c"
  instance_type   = "t2.micro"
  tags = {
    Name = "nop"
  }
}
output "nop_url" {
  value = aws_instance.nop.public_ip
}