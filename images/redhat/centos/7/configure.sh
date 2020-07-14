#!/bin/bash

# Enable ssh service
systemctl enable sshd;

# Start ssh service
systemctl start sshd;

exec /usr/sbin/init
