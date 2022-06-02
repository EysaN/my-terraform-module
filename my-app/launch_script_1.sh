#!/bin/bash

sudo yum update -y

sudo amazon-linux-extras install nginx1

ins_id=$(curl http://169.254.169.254/latest/meta-data/instance-id)
private_ip=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
public_ip=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
aws ec2 describe-instance-status --instance-ids $ins_id --region eu-central-1 > status_response.json
state=$(jq -r .InstanceStatuses[0].InstanceState.Name status_response.json)
av_name=$(jq -r .InstanceStatuses[0].AvailabilityZone status_response.json)
health_1=$(jq -r .InstanceStatuses[0].InstanceStatus.Status status_response.json)
health_2=$(jq -r .InstanceStatuses[0].InstanceStatus.Details[0].Status status_response.json)

sudo tee /usr/share/nginx/html/index.html<<EOF
<!--[if IE]><meta http-equiv="X-UA-Compatible" content="IE=5,IE=9" ><![endif]-->
<!DOCTYPE html>
<html>
<head>
<title>Terraform Task - Eysa Nemeh</title>
<meta charset="utf-8"/>
<style>
    .container {
        font-family: arial;
        font-size: 24px;
        margin: 10%;
        align-items: center;
    }
    h2, h3 {
        /* Center horizontally*/
        text-align: center;
    }
</style>
</head>
<body>
    <div class="container"> 
        <h2>EC2 Instance ID: $ins_id</h2> 
        <br/> 
        <h3>Private IP of EC2: $private_ip</h3> 
        <br/> 
        <h3>Public IP of EC2: $public_ip</h3>  
        <br/> 
        <h3>Current state: $state</h3>
        <br/> 
        <h3>Currnet AZ: $av_name</h3> 
        <br/> 
        <h3>Currnet Health State: $health_1/$health_2</h3> 
    </div>
</body>
</html>
EOF

sudo rm status_response.json

sudo systemctl enable nginx
sudo systemctl start nginx