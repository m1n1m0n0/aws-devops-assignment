#!/bin/bash
# Run step by step (copy/paste), not blindly. Replace m1n1m0n0 first.
# Creates the 5+ meaningful commits and shows clone/status/add/commit/push/pull/branch/checkout/merge.
set -e
git clone https://github.com/m1n1m0n0/aws-devops-assignment.git   # empty repo created on GitHub
cd aws-devops-assignment
git status
# copy the starter files here, then commit in small steps:
git add .gitignore README.md docs/ && git commit -m "Initial project structure"
git add website/ && git commit -m "Add website"
git add scripts/user-data.sh && git commit -m "Add User Data script"
git add cloudformation/ && git commit -m "Add CloudFormation template"
git add docs/security.md docs/troubleshooting.md && git commit -m "Add monitoring and security documentation"
git branch -M main
git push -u origin main
git checkout -b develop
git push -u origin develop
git checkout -b feature/update-website develop
# ...edit website/index.html...
git add website && git commit -m "Update website text"
git checkout develop
git merge feature/update-website
git push
git checkout main && git merge develop && git push
git pull
git log --oneline --graph
