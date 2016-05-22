#!/usr/bin/env bash
set -e

{

# Crazy memory use otherwise??
setenforce 0

# Sane hostname
hostnamectl set-hostname ${fqdn}

# Install packages
yum -y install epel-release
yum -y update
yum -y install curl unzip jq

# Download Vault into some temporary directory
curl -L "${download_url}" > /tmp/vault.zip

# Unzip it
dBin=/usr/sbin
cd /tmp
unzip vault.zip
mv vault $dBin
chmod -v 0755 $dBin/vault
chown -v root:root $dBin/vault

# Setup the configuration
cat <<EOFEOF >/tmp/vault-config
${config}
EOFEOF
echo Replacing \' with \" in /etc/hashicorpvault.json ...
cat /tmp/vault-config | sed s:\':\":g | jq . > /etc/hashicorpvault.json

# Setup the init script
cat <<EOFEOF >/tmp/systemd.init
[Unit]
Description=Hashicorp Vault Server
After=syslog.target network.target

[Service]
Type=simple
User=root
ExecStart=/usr/sbin/vault server -config=/etc/hashicorpvault.json

[Install]
WantedBy=multi-user.target
EOFEOF
mv -v /tmp/systemd.init /etc/systemd/system/hashicorpvault.service
chmod -v 0664 /etc/systemd/system/hashicorpvault.service
systemctl daemon-reload

# Extra install steps (if any)
${extra-install}

# Start Vault
systemctl start hashicorpvault

} 2>&1 | tee -a /root/vault-install.log
