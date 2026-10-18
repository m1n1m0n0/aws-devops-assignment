# Troubleshooting

Method: **Symptom -> Possible causes -> Smallest test -> Root cause -> Fix -> Verification.**
Both cases were reproduced on the manual EC2 instance (`aws-devops-web`) using the AWS CLI in CloudShell (us-east-2).

## Case 1 - Website times out (Security Group blocks HTTP)
| Step | Notes |
|---|---|
| Symptom | `curl -I --max-time 10 http://<public-ip>` fails with `curl: (28) Connection timed out after 10002 milliseconds`; the browser spins and times out. Before the change the same command returned `200 OK`. |
| Possible causes | Instance stopped; Security Group lacks port 80; no route to the Internet gateway; Apache not running; wrong IP |
| Smallest test | 1) Instance state is `running`. 2) `aws ec2 describe-security-groups --group-ids <sg-id> --query "SecurityGroups[0].IpPermissions[].[IpProtocol,FromPort,ToPort]" --output text` |
| Root cause | The inbound rule for HTTP (TCP 80 from 0.0.0.0/0) was removed. Only `tcp 22 22` remained, so the Security Group dropped web traffic. |
| Fix | `aws ec2 authorize-security-group-ingress --group-id <sg-id> --protocol tcp --port 80 --cidr 0.0.0.0/0` |
| Verification | `curl -I http://<public-ip>` returns `HTTP/1.1 200 OK` (Apache/2.4.69). Evidence: `screenshots/ts1-start.png` (baseline), `screenshots/ts1-broken.png` (timeout + Security Group showing only port 22), `screenshots/ts1-fixed.png`. |

## Case 2 - Instance stopped (no public IP)
| Step | Notes |
|---|---|
| Symptom | The website times out again: `curl: (28) Connection timed out after 10002 milliseconds`. |
| Possible causes | Instance stopped or terminated; Security Group rule missing; Apache not running; IP changed |
| Smallest test | `aws ec2 describe-instances --instance-ids <id> --query "Reservations[0].Instances[0].[State.Name,PublicIpAddress]" --output text` |
| Root cause | The instance was stopped. The output was `stopped None`: not running and no public IPv4 address. |
| Fix | `aws ec2 start-instances --instance-ids <id>`, then `aws ec2 wait instance-running --instance-ids <id>`. A stop/start assigns a **new** public IP, so the old address no longer works; use the new one (an Elastic IP would keep it fixed). |
| Verification | State `running`, new public IP, and `curl -I http://<new-ip>` returns `HTTP/1.1 200 OK`. Evidence: `screenshots/ts2-broken.png`, `screenshots/ts2-fixed.png`. |

## Lessons learned
- Work from the outside in: instance state, then network (Security Group, route), then the service on the host.
- A timeout (no response) usually means a network block or a stopped instance; "connection refused" would point to a service that is not listening.
- Public IPs change after a stop/start; use an Elastic IP or DNS if a stable address is needed.

Useful commands: `aws ec2 describe-instances`, `aws ec2 describe-security-groups`, `journalctl -u httpd`, `/var/log/user-data.log`, `aws cloudformation describe-stack-events`.
