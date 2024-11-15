#!/bin/bash
set -e

echo "Installing Server and openssh"
apt-get update && apt-get install -y openssh-client curl

echo "$SSH_KEY" > /tmp/ssh_key
chmod 600 /tmp/ssh_key

ssh -i /tmp/ssh_key -o StrictHostKeyChecking=no "$SSH_USER@$SSH_HOST" << EOF
  if [ ! -d "/home/$SSH_USER/server" ]; then
    echo "Directory /home/$SSH_USER/server does not exist. Setting up server..."
    
    # Update Linux packages
    sudo apt update -y && sudo apt upgrade -y

    # Install Docker
    echo "Installing Docker..."
    sudo apt install -y docker.io

    # Install Docker Compose
    echo "Installing Docker Compose..."
    DOCKER_COMPOSE_VERSION=\$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
    sudo curl -L "https://github.com/docker/compose/releases/download/\$DOCKER_COMPOSE_VERSION/docker-compose-\$(uname -s)-\$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

    # Verify Docker Compose installation
    docker-compose --version

    # Create the server directory
    sudo mkdir -p /home/$SSH_USER/server
    echo "Server setup completed."
  else
    echo "Directory /home/$SSH_USER/server already exists. Skipping setup."
  fi
EOF
