# AWS MFA Credentials Automation Script

# Hardcoded ARN of the MFA device
$serialNumber = "arn:aws:iam::1234567890:mfa/username" 

# Prompt for MFA code
$mfaCode = Read-Host "Enter your MFA code"

# Get session token using AWS CLI
try {
    $sessionToken = aws sts get-session-token --serial-number $serialNumber --token-code $mfaCode | ConvertFrom-Json
}
catch {
    Write-Host "Error getting session token. Error details: $_"
    exit 1
}

# Check if we got valid credentials
if (-not $sessionToken.Credentials) {
    Write-Host "Failed to get valid credentials. Please check your MFA code and try again."
    exit 1
}

# Extract credentials from the session token
$accessKeyId = $sessionToken.Credentials.AccessKeyId
$secretAccessKey = $sessionToken.Credentials.SecretAccessKey
$sessionTokenString = $sessionToken.Credentials.SessionToken

# Define the path to the AWS credentials file
$credentialsFile = "$env:USERPROFILE\.aws\credentials"

# Read existing credentials file content
$existingContent = Get-Content -Path $credentialsFile -Raw

# Create new profile content
$newProfileContent = @"

[profile1]
aws_access_key_id = $accessKeyId
aws_secret_access_key = $secretAccessKey
aws_session_token = $sessionTokenString
"@

# Check if the 'profile1' profile already exists
if ($existingContent -match '\[profile1\]') {
    # Replace existing 'profile1' profile
    $updatedContent = $existingContent -replace '(?ms)\[profile1\].*?(\[|$)', $newProfileContent
} else {
    # Append new 'profile1' profile
    $updatedContent = $existingContent + $newProfileContent
}

# Write the updated content back to the credentials file
Set-Content -Path $credentialsFile -Value $updatedContent

Write-Host "AWS credentials have been updated successfully. A new profile 'profile1' has been created with the temporary session token."
Write-Host "To use these credentials, specify --profile profile1 in your AWS CLI commands or set the AWS_PROFILE environment variable to 'profile1'."