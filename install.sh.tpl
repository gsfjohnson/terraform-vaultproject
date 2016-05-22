#!/usr/bin/env bash
set -e

# Sane hostname
hostnamectl set-hostname ${fqdn}

# Install packages
sudo yum -y update
sudo yum -y install curl unzip

# Download Vault into some temporary directory
curl -L "${download_url}" > /tmp/vault.zip

# Unzip it
cd /tmp
sudo unzip vault.zip
sudo mv vault /usr/local/bin
sudo chmod 0755 /usr/local/bin/vault
sudo chown root:root /usr/local/bin/vault

# Setup the configuration
cat <<EOFEOF >/tmp/vault-config
${config}
EOFEOF
sudo mv /tmp/vault-config /usr/local/etc/vault-config.json

# Setup the init script
cat <<EOFEOF >/tmp/systemd.init
[Unit]
Description=Hashicorp Vault
After=syslog.target network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/vault server -config="/usr/local/etc/vault-config.json"

[Install]
WantedBy=multi-user.target
EOFEOF
#sudo mv /tmp/systemd.init /etc/init/vault.conf

# Extra install steps (if any)
${extra-install}

# Start Vault
#sudo start vault
