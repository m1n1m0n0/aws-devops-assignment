#!/bin/bash
# User data for the Auto Scaling Group instances (Amazon Linux 2023).
# Installs Apache and writes a page that shows which instance served the request.
dnf install -y httpd
systemctl enable --now httpd

# IMDSv2: get a session token, then read instance metadata
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 300")
IID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)

cat > /var/www/html/index.html <<HTML
<!DOCTYPE html>
<html lang="en"><head><meta charset="utf-8"><title>AWS DevOps Assignment - ASG</title></head>
<body>
<h1>Welcome to AWS DevOps Assignment</h1>
<p>Served by instance <b>${IID}</b> in <b>${AZ}</b> (Application Load Balancer + Auto Scaling Group)</p>
</body></html>
HTML
