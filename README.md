## Setup-Server
This GitHub Action allows for automated deployment to a remote server based on specific commit messages. It is designed to set up and deploy a server directory only when a commit message follows the pattern:
```deploy - h SERVER_IP - u USER```.

## Usage
### Prerequisites
1. **Add SSH Key:** Add your private SSH key to the repository secrets as `SSH_KEY`.
2. **Commit Message Format:** Use the following format to trigger deployment:
  ```bash
  deploy - h SERVER_IP - u USER
  ```
Replace:
- `SERVER_IP`: The IP address of the target server.
- `USER`: The username to SSH into the server.

---
### Example Workflow

```yaml
name: custom
on:
push:
 branches:
   - main

jobs:
main:
 runs-on: ubuntu-latest
 steps:
   - name: Checkout Repository
     uses: actions/checkout@v3

   - name: Check Commit Message for Deployment
     id: check_message
     run: |
       # Check if the commit message matches the deployment pattern
       if [[ "${{ github.event.head_commit.message }}" =~ deploy\ -\ h\ ([0-9]{1,3}\.){3}[0-9]{1,3}\ -\ u\ [a-zA-Z0-9_]+ ]]; then
         echo "Deployment commit detected. Extracting SERVER_IP and USER..."
         SERVER_IP=$(echo "${{ github.event.head_commit.message }}" | grep -oP "(?<=deploy - h )([0-9]{1,3}\.){3}[0-9]{1,3}")
         USER=$(echo "${{ github.event.head_commit.message }}" | grep -oP "(?<=- u )[a-zA-Z0-9_]+")
         echo "SERVER_IP=${SERVER_IP}" >> $GITHUB_ENV
         echo "SSH_USER=${USER}" >> $GITHUB_ENV
       else
         echo "No valid deployment commit detected. Skipping deployment."
         exit 0
       fi

   - name: Run Setup for Bharat Seva
     # if any of SERVER_IP or SSH_USER is present then it will be executed
     # instead SSH_HOST or SSH_USER will be used inplace
     if: env.SERVER_IP != '' && env.SSH_USER != ''
     uses: vaibhavyadav-dev/setup-server@main
     env:
       SSH_KEY: ${{ secrets.SSH_KEY }}
       SSH_USER: ${{ env.SSH_USER }}
       SSH_HOST: ${{ env.SERVER_IP }}
```

### How It Works
Triggering the Workflow:

The workflow runs whenever a push is made to the main branch.
Commit Message Validation:
The workflow checks if the latest commit message follows the format:
```bash
deploy - h SERVER_IP - u USER
```
If the format matches:
Extracts SERVER_IP (the server's IP address) and USER (the SSH username).
These values are set as environment variables for the subsequent steps.  

Deployment Execution:
The Setup-Server action connects to the specified server using the extracted SERVER_IP and USER.  
Sets up the server directory and installs required packages like Docker and Docker Compose.

### Skipping Deployment:
If the commit message does not match the required format, the workflow exits without running further steps.  
Secrets Configuration

### Make sure to configure the following secrets in your GitHub repository:
Secret Name	Description
- SSH_KEY	Private SSH key for connecting to the server.
- SSH_USER	Default SSH username (optional fallback).
- SSH_HOST	Default SSH host (optional fallback).  

### Commit Message Format  
To trigger the deployment, use a commit message like this:

```bash
  deploy - h 192.168.1.10 - u azureuser
```
SERVER_IP: The target server's IP address.
USER: The SSH username to connect to the server.
## Notes
Ensure the target server has SSH access enabled and the provided SSH key is authorized.
Modify the workflow to suit your specific deployment requirements.
## License
This action is licensed under the MIT License. Feel free to use and modify it!
