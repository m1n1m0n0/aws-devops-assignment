# Troubleshooting

Method: **Symptom -> Possible causes -> Smallest test -> Root cause -> Fix -> Verification.**
Fill in each case when the instructor introduces the failure.

## Case 1 - (example: website times out)
| Step | Notes |
|---|---|
| Symptom | Browser spins and times out on `http://<public-ip>` |
| Possible causes | Instance stopped; Security Group lacks port 80; no route to Internet gateway; Apache not running; wrong IP |
| Smallest test | Check instance state; check SG inbound rules; `curl -I http://<ip>` ; on the host `systemctl status httpd` |
| Root cause | _write what you found_ |
| Fix | _what you changed_ |
| Verification | `curl -I` returns `200 OK`; screenshot saved as `screenshots/ts1-fixed.png` |

## Case 2 - (example: instance stopped/terminated)
| Step | Notes |
|---|---|
| Symptom | |
| Possible causes | |
| Smallest test | |
| Root cause | |
| Fix | |
| Verification | |

Useful commands: `aws ec2 describe-instances`, `aws ec2 describe-security-groups`, `journalctl -u httpd`, `/var/log/user-data.log`, `aws cloudformation describe-stack-events`.
