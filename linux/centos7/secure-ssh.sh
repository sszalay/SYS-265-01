#secure-ssh.sh
#author scott
#creates a new ssh user using $1 parameter
#adds a public key from the local repo or curled from the remote repo
#removes roots ability to ssh in
echo "ADD ALL CODE HERE"

# Check if username is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

USERNAME=$1
USER_HOME="/home/$USERNAME"
SSH_DIR="$USER_HOME/.ssh"
AUTHORIZED_KEYS="$SSH_DIR/authorized_keys"
PUB_KEY_SOURCE="SYS-265-01/linux/public-keys/id_rsa.pub" 

# Create the user with home directory and bash shell
sudo useradd -m -d "$USER_HOME" -s /bin/bash "$USERNAME"
echo "User $USERNAME created."

# Create SSH directory
sudo mkdir -p "$SSH_DIR"
sudo chmod 700 "$SSH_DIR"
sudo chown "$USERNAME:$USERNAME" "$SSH_DIR"
echo "SSH directory created and permissions set."

# Copy the public key to authorized_keys
if [ -f "$PUB_KEY_SOURCE" ]; then
    sudo cp "$PUB_KEY_SOURCE" "$AUTHORIZED_KEYS"
    sudo chmod 600 "$AUTHORIZED_KEYS"
    sudo chown "$USERNAME:$USERNAME" "$AUTHORIZED_KEYS"
    echo "Public key copied to authorized_keys."
else
    echo "Error: Public key file not found at $PUB_KEY_SOURCE."
    exit 1
fi

# Disable password authentication for the user
sudo passwd -l "$USERNAME"

echo "User $USERNAME has been created and can only log in using an RSA private key."

