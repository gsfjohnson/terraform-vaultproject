#!/usr/bin/env bash
set -e

{

# Crazy memory use otherwise??
setenforce 0

# Sane hostname
hostnamectl set-hostname ${fqdn}

# Install packages
yum -y update
yum -y install curl unzip

# Download Vault into some temporary directory
curl -L "${download_url}" > /tmp/vault.zip

# Unzip it
cd /tmp
unzip vault.zip
mv vault /usr/local/bin
chmod 0755 /usr/local/bin/vault
chown root:root /usr/local/bin/vault

# Setup the configuration
cat <<EOFEOF >/tmp/vault-config
${config}
EOFEOF
mv /tmp/vault-config /usr/local/etc/vault-config.json

# Setup the init script
cat <<EOFEOF >/tmp/systemd.init
[Unit]
Description=Hashicorp Vault Server
After=syslog.target network.target

[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/vault server -config="/usr/local/etc/vault-config.json"

[Install]
WantedBy=multi-user.target
EOFEOF
#mv /tmp/systemd.init /etc/init/vault.conf

# Extra install steps (if any)
${extra-install}

# Start Vault
#start vault

} 2>&1 | tee -a /root/vault-install.log
