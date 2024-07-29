# AWS MFA Credentials Automation Script

This PowerShell script automates obtaining temporary AWS credentials using Multi-Factor Authentication (MFA). It preserves existing default credentials while creating a new profile named "profile1" for temporary credentials.

## Usage
1. Replace `$serialNumber` in the script with your MFA device ARN.
2. Run `.\set-aws-session.ps1` in PowerShell.
3. Enter your MFA code when prompted.

If getting permissions ERROR :
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

Use temporary credentials with: `aws s3 ls --profile profile1` 

Ensure AWS CLI is installed and configured with default credentials before use.
