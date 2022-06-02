#!/bin/bash

sudo yum update -y

sudo amazon-linux-extras install nginx1

ins_id=$(curl http://169.254.169.254/latest/meta-data/instance-id)
private_ip=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
public_ip=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)

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
    </div>
</body>
</html>
EOF

sudo systemctl enable nginx
sudo systemctl start nginx