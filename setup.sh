#!/bin/bash
set -e

echo "$SSH_KEY" > /tmp/ssh_key
chmod 600 /tmp/ssh_key

ssh -i /tmp/ssh_key -o StrictHostKeyChecking=no "$SSH_USER@$SSH_HOST" << 'EOF'
  if [ ! -d "/home/$SSH_USER/server" ]; then
    echo "Directory /home/$SSH_USER/server does not exist. Setting up server..."
    # Update Linux
    sudo apt update -y && sudo apt upgrade -y

    # Install Docker
    sudo apt install -y docker.io

    # Make the server directory
    sudo mkdir -p /home/$SSH_USER/server
  else
    echo "Directory /home/$SSH_USER/server already exists. Skipping setup."
  fi
EOF
