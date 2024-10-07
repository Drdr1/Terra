resource "tls_private_key" "terraform_generated_private_key" {
  algorithm = var.e_nkind 
  rsa_bits  = var.num_bits
}


resource "aws_key_pair" "TF_key" {
  key_name   = "key-pair"
  public_key = tls_private_key.terraform_generated_private_key.public_key_openssh
}


resource "null_resource" "TF_key_file" {
  provisioner "local-exec" {
    command = <<-EOT
      echo '${tls_private_key.terraform_generated_private_key.private_key_pem}' > TF_key.pem
      chmod 400 TF_key.pem
    EOT
  }

  
  depends_on = [aws_key_pair.TF_key]

}