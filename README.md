# k8s-cluster-ops
This repo contains code to create a k8s cluster on eks which is required by various organizations in their day to day operation.

## Infra components

 1. Vault
 2. Kafka
 3. Ingress-Nginx
 4. Cert-Manager

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTIwNDQ5Mzg0MDEsMTQwMDk0ODA5XX0=
-->

## Steps to run

1. You have to first create a s3 bucket inorder to store terraform.tfstate. You can either create it manually or use backend_s3.tf file (uncomment it) in isolatation to create a s3 bcuket and then comment it back.
2. edit the bucket name in backend.tf file with the bucket you created.
3. install aws cli and then configure a profile (i have use us-east-1 as a default region)
```
aws configure --profile k8s-cluster-ops
```
4. To run the project
```
make init
make apply
```
