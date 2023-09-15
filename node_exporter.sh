#!/bin/bash

set -eo

# Create a directory for node_exporter and navigate to it
mkdir -p node_exporter
cd node_exporter || exit 1

# Download node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz

# Extract the downloaded archive
tar xvfz node_exporter-1.6.1.linux-amd64.tar.gz

# Copy node_exporter to /usr/local/bin
sudo cp node_exporter-1.6.1.linux-amd64/node_exporter /usr/local/bin/node_exporter

# Remove the downloaded archive
rm -f node_exporter-1.6.1.linux-amd64.tar.gz

# Create a systemd service file for node_exporter
sudo tee /etc/systemd/system/node_exporter.service <<EOF
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

# Make sure the node_exporter binary is executable
sudo chmod +x /usr/local/bin/node_exporter

# Create the node_exporter user with a restricted shell
sudo useradd -rs /bin/false node_exporter

# Start and enable the node_exporter service

sudo systemctl start node_exporter


# Verify that node_exporter is running
sudo systemctl status node_exporter

echo "Node Exporter has been installed and started."


