#!/bin/bash

# Listen for ssh connection
sudo iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT;

# Start sshd service
service sshd start;

# Keep container running
tail -f /dev/null;