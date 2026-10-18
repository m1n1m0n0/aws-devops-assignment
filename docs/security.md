# Security

## Security Groups and least privilege
| Rule | Source | Why |
|---|---|---|
| HTTP 80 | 0.0.0.0/0 | The website must be public |
| SSH 22 | The student's own public IP as a single /32 (not published in this repo) | Administration only from the student IP; never 0.0.0.0/0 |

**Why SSH must not be open to 0.0.0.0/0:** the Internet is scanned constantly; an open port 22 attracts brute-force and credential-stuffing attempts, and one weak key or password gives full control of the server. Limiting it to one IP (or using Session Manager) shrinks the attack surface to almost nothing. Outbound traffic is left at the default for package installs.

## IAM
The instance uses an IAM role through an instance profile with only: read access to the one S3 bucket and the CloudWatch agent policy.

**Why roles beat hard-coded access keys:** a role issues short-lived credentials that rotate automatically, are never written to disk or Git, and are scoped by policy. Static keys can leak (images, logs, repos), do not expire and must be rotated by hand.

## S3 access decisions
Block Public Access stays **on**, versioning is **on** (recovery from overwrite/delete), default encryption SSE-S3. The website is served from EC2, so the bucket never needs to be public. Reason for any change must be documented here: _none made_.

## Secret handling
- No access keys, passwords, tokens or `.pem` files in Git (`.gitignore` blocks common ones).
- Parameters and roles in CloudFormation; the alert email and IP are parameters, not hard-coded.
- IMDSv2 is required on the instance (token-based metadata).
- If a secret is ever committed: revoke it immediately, then clean history.
