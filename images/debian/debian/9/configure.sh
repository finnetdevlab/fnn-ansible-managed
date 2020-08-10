#!/bin/bash

# Enable ssh service
# Use full service name to avoid too many levels of symbolic links
systemctl enable ssh.service;

# Start ssh service
systemctl start ssh.service;

exec /lib/systemd/systemd