#!/bin/bash

# Enable ssh service
chkconfig --add sshd;
chkconfig --level 2345 sshd on;

# Start ssh service
service sshd start;

exec /sbin/init