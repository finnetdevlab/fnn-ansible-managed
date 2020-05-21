#!/bin/bash

# Remove no login flags
rm -f /{var/run,etc,run}/nologin;

# Listen for ssh connection
sudo iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT;