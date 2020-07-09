#!/bin/bash

# Enable ssh service
systemctl enable sshd;

# Start ssh service
systemctl start sshd;

# Remove nologin files to prevent authentication failure -- See https://access.redhat.com/discussions/4321031
# This files are created after systemd call. Delete them after some delay.
( sleep 10 ; rm -f /{var/run,etc,run}/nologin ) &

exec /usr/sbin/init