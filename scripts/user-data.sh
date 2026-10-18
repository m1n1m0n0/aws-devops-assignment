#!/bin/bash
# EC2 User Data for Amazon Linux 2023: installs and starts Apache, publishes the site.
# Runs once as root on first boot. Log: /var/log/user-data.log
set -euxo pipefail
exec > >(tee /var/log/user-data.log) 2>&1

dnf update -y
dnf install -y httpd
systemctl enable --now httpd

# IMDSv2: fetch instance metadata with a session token (no credentials involved)
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 300")
AZ=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)
IID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)

cat > /var/www/html/index.html <<HTML
<!DOCTYPE html>
<html lang="en"><head><meta charset="utf-8"><title>AWS DevOps Assignment</title></head>
<body style="font-family:system-ui,Arial,sans-serif;max-width:640px;margin:10vh auto">
<h1>Welcome to AWS DevOps Assignment</h1>
<ul>
<li><b>Student name:</b> alexr</li>
<li><b>Role:</b> Junior DevOps Engineer</li>
<li><b>Module:</b> AWS Cloud Foundations</li>
<li><b>GitHub repository:</b> https://github.com/m1n1m0n0/aws-devops-assignment</li>
<li><b>Instance:</b> ${IID} in ${AZ}</li>
</ul></body></html>
HTML
systemctl restart httpd
