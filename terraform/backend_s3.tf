# we need to create a s3 bucket as we cannot dynamically pass s3 bucket name in backend.tf file
# terraform/s3.tf

# resource "random_string" "s3_suffix" {
#   length  = 6
#   upper   = false
#   lower   = true
#   numeric = true
#   special = false
# }

# resource "aws_s3_bucket" "tf_state_bucket" {
#   bucket = "k8s-cluster-ops-${random_string.s3_suffix.result}-backend-bucket"
# }

# resource "aws_s3_bucket_versioning" "tf_state_bucket_versioning" {
#   bucket = aws_s3_bucket.tf_state_bucket.id

#   versioning_configuration {
#     status = "Enabled"
#   }
# }
