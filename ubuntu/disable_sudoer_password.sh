#!/bin/bash
echo "`whoami` ALL=(ALL) NOPASSWD: ALL" > /tmp/`whoami` 
chmod 440 /tmp/`whoami`
sudo chown root:root /tmp/`whoami`
sudo mv /tmp/`whoami` /etc/sudoers.d/
