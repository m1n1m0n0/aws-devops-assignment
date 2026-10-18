# AWS CLI / CloudShell commands used (need at least 5)

| # | Command | What it does |
|---|---|---|
| 1 | `aws sts get-caller-identity` | Shows which account/user the CLI is acting as |
| 2 | `aws s3 mb s3://<bucket-name>` | Creates a bucket |
| 3 | `aws s3 cp website/index.html s3://<bucket-name>/` | Uploads a file to the bucket |
| 4 | `aws s3 ls s3://<bucket-name>/` | Lists objects in the bucket |
| 5 | `aws s3api get-bucket-versioning --bucket <bucket-name>` | Shows whether versioning is enabled |
| 6 | `aws ec2 describe-instances --query "Reservations[].Instances[].[InstanceId,State.Name,PublicIpAddress]" --output table` | Lists instances with state and public IP |
| 7 | `aws cloudformation validate-template --template-body file://cloudformation/infrastructure.yaml` | Checks template syntax |
| 8 | `aws cloudformation describe-stack-events --stack-name <stack>` | Shows create/update events (first place to look on failures) |

Paste your real output as screenshots in `screenshots/`.
