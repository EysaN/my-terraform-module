# Simple Terraform Module

 * state file is saved locally
 * Used provider is AWS
 * AWS Region: Europe (Frankfurt) eu-central-1
 * Access keys must be provided in main.tf file


### Description
Nginx application running on an EC2 instance configured by a launch template and provisioned in an ASG

Simple scaling policies are created to add/remove instances by 1 capacity unit when the average CPU of the AGS exceeds/drops down 50%

The ASG capacity is configured as: desired = 1, min = 1, max = 2

The app runs behind an ALB and strictly though the ALB DNS name on port 80

The ALB is linked to an alias Route53 record

### Variables needed for the module are
 + app_name: name of the application
 + env: the application environment (dev, test, staging, prod)
 + image_id: the id of the image used in launch templates (default = Amazon Linux 2 / kernal 5.10)
 + instance_type: the EC2 isntance type used in launch templates (default = t2.micro)
 + iam_instance_profile: the name of the iam instance profile used in launch template
 + key_name: the ec2 key pair
 + user_data: the scripts executed at ec2 launch
 + domain: the main domain to reach the app