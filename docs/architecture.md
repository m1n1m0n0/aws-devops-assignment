# Architecture

![Architecture diagram](architecture.svg)

| Component | Purpose | Connects to |
|---|---|---|
| Internet / user | Visits the website (HTTP 80); the administrator uses SSH (22) | Security Group |
| Internet gateway + route table | Gives the public subnet a route to the Internet | VPC |
| Security Group | Stateful firewall: HTTP from anywhere, SSH from the student IP only | EC2 |
| EC2 web server | Amazon Linux 2023 running Apache, installed automatically by User Data | EBS, IAM role |
| EBS volume | Encrypted gp3 root volume (block storage, attached to one instance) | EC2 |
| IAM role (instance profile) | Gives the instance temporary credentials, no access keys on the box | S3, CloudWatch |
| Amazon S3 bucket | Versioned object storage, Block Public Access on | IAM role |
| CloudWatch alarm | `CPUUtilization > 70%` for 5 minutes | SNS |
| SNS topic | Sends the alarm email | Student email |

## Traffic and data flows
1. User -> Internet -> Security Group (port 80) -> EC2 -> web page.
2. Administrator -> Security Group (port 22, student IP only) -> EC2.
3. EC2 -> IAM role credentials -> S3 (read objects).
4. EC2 metrics -> CloudWatch alarm -> SNS -> email.

## S3 vs EBS
S3 is object storage: accessed over HTTPS by key, practically unlimited, versioned and shared across services and Regions. EBS is block storage: a disk attached to one EC2 instance in one Availability Zone, used for the OS and for data needing a file system with low latency.
